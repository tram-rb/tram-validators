# Validates attribute by calling given type with the attribute's value
#
# @example Checks that AdminPolicy.new(user).valid?
#   validates :user, contract: { policy: AdminPolicy, nested_keys: true }
#
class ContractValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless options[:policy]
    options[:policy].new(value).tap(&:valid?).errors.messages.each do |key, msg|
      msg.each { |message| record.errors.add name(attribute, key), message }
    end
  end

  private

  def name(attribute, key)
    return "#{attribute}[#{key}]" if options[:nested_keys]
    options[:original_keys] ? key : attribute
  end
end
