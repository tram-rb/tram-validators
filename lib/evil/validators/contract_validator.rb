# Validates attribute by calling given type with the attribute's value
#
# @example Checks that AdminPolicy.new(user).valid?
#   validates :user, contract: { policy: AdminPolicy, nested_keys: true }
#
class ContractValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless options[:policy]
    options[:policy].new(value).tap(&:valid?).errors.messages.each do |key, msg|
      error_key = Evil::Validators.error_key(key, attribute, options)
      msg.each { |message| record.errors.add error_key, message }
    end
  end
end
