# Validates attribute by applying validation rule not to the attribute itself,
# but to another parameter, whose value depends on the attribute.
#
# The resulting error is collected under the attribute's key, which
# is necessary to correctly bind the error to the field, that causes
# the problem.
#
# @example
#   let(:user) { User.find_by(id: user_id) }
#   validates :user_id, outcome: { value: 'user.name', presence: true }
#   # user_id.user_name_presence
#
class OutcomeValidator < ActiveModel::EachValidator
  # rubocop: disable Metrics/MethodLength
  def validate_each(record, attribute, value)
    dependency = options[:value].to_s.gsub(".", "_")
    dependent  = Tram::Validators.chained_value(record, options[:value])
    validators = Tram::Validators.validators(@attributes, options, :value)

    sandbox = record.dup
    validators.each do |condition, validator|
      next if valid_in_sandbox(sandbox, attribute, dependent, validator)

      key = message_key(dependency, condition)
      record.errors.add attribute, key, model:       record,
                                        attribute:   attribute,
                                        value:       value,
                                        delependent: dependent
    end
  end
  # rubocop: enable Metrics/MethodLength

  private

  def valid_in_sandbox(sandbox, attribute, dependent, validator)
    sandbox.errors.clear
    validator.validate_each(sandbox, attribute, dependent)
    sandbox.errors.empty?
  end

  def message_key(dependency, condition)
    [dependency, condition.to_s].compact.join("_").to_sym
  end
end
