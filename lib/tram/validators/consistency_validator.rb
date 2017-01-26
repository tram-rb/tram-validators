# Compares value of the attribute to value of another attribute
#
# @example Compares price to source.price
#   validates :price, consistency: { greater_than: 'source.price' }
#   # I18n error key 'price.greater_than_source.price'
#
class ConsistencyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    Tram::Validators::CONDITIONS.each do |key, block|
      check(key, record, attribute, value, &block)
    end
  end

  private

  def check(condition, record, attribute, value)
    chain = options[condition]
    return if chain.blank?

    other_value = Tram::Validators.chained_value(record, chain)
    return if value && other_value && yield(value, other_value)

    error_name = [condition, chain.to_s.split(".")].flatten.join("_").to_sym
    record.errors.add attribute, error_name, value: value, other: other_value
  end
end
