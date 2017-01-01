# Applies validator to every element of the collection
class EachValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    return unless values.respond_to? :to_a
    values.to_a.each_with_index do |value, index|
      # This is needed to generate original errors under attribute's onw key...
      item = record.dup.tap { |rec| rec.errors.clear }

      call_validations(item, attribute, value)

      # ...and here we collect string messages into original record
      #    under new key which can be used by native error generator
      #    because the attribute[i] is not a valid method name
      item.errors.messages[attribute].each do |message|
        record.errors.add :"#{attribute}[#{index}]", message
      end
    end
  end

  private

  def call_validations(item, attribute, value)
    Evil::Validators.validators(@attributes, options).each do |_, validator|
      validator.validate_each item, attribute, value
    end
  end
end
