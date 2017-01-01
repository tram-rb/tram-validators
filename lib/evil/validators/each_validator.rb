# Applies validator to every element of the collection
class EachValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    return unless values.respond_to? :to_a
    values.to_a.each_with_index do |value, index|
      # This is needed to generate original errors under attribute's onw key...
      item = record.dup.tap { |rec| rec.errors.clear }

      Evil::Validators.validators(@attributes, options).each do |validator|
        validator.validate_each item, attribute, value
      end

      # ...and here we collect string messages into original record
      #    under new key which can be used by native error generator
      #    because the attribute[i] is not a valid method name
      item.errors.messages[attribute].each do |message|
        record.errors.add :"#{attribute}[#{index}]", message
      end
    end
  end
end
