# Applies validator to every element of the collection
class EachValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    return unless values.is_a? Enumerable
    values.each_with_index do |value, index|
      item = record.dup.tap { |rec| rec.errors.clear }

      call_validations(item, attribute, value)

      copy_errors(item, record, attribute, index)
    end
  end

  private

  def call_validations(item, attribute, value)
    Tram::Validators.validators(@attributes, options).each do |_, validator|
      validator.validate_each item, attribute, value
    end
  end

  def copy_errors(item, record, attribute, index)
    item.errors.messages.each do |original_key, messages|
      messages.each do |message|
        key = original_key.to_s.sub /\A#{attribute}/, "#{attribute}[#{index}]"
        record.errors.add key.to_sym, message
      end
    end
  end
end
