# Validates attribute by calling given type with the attribute's value
#
# @example Checks that AdminPolicy.new(user).valid?
#   validates :user, contract: { policy: AdminPolicy, nested_keys: true }
#
class ContractValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    policy = options[:policy]
    return unless policy

    source = policy.new(value)
    return if source.valid?

    key = "contract_#{policy.name.underscore}"
    Tram::Validators.copy_errors(source, record, attribute, key, value, options)
  end
end
