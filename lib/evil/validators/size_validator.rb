# Compares size of array to given value or another attribute
#
# @example
#   validates :names,  size: { less_than: 6 }
#   validates :values, size: { equal_to: :names }
#
class SizeValidator < ActiveModel::EachValidator
  CONDITIONS = {
    equal_to:                 ->(size, limit) { size == limit },
    other_than:               ->(size, limit) { size != limit },
    less_than:                ->(size, limit) { size <  limit },
    less_than_or_equal_to:    ->(size, limit) { size <= limit },
    greater_than:             ->(size, limit) { size >  limit },
    greater_than_or_equal_to: ->(size, limit) { size >= limit }
  }.freeze

  def validate_each(record, attribute, value)
    size = value.size if value.is_a? Array
    CONDITIONS.each { |key, block| check(key, record, attribute, size, &block) }
  end

  private

  def check(condition, record, attribute, size)
    return unless options.key? condition

    limit = extract_limit(record, condition)
    return if size && limit && yield(size, limit.to_i)

    record.errors.add attribute, error_key(condition), size: size, limit: limit
  end

  def extract_limit(record, condition)
    value = options[condition]
    return value.to_s.to_i if value.to_s.to_i == value
    value.to_s.split(".").inject(record) { |obj, meth| obj&.send(meth) }
  end

  def error_key(condition)
    value = options[condition]
    name = value.to_s.underscore.gsub(".", "_") unless value.to_s.to_i == value
    ["size", condition, name].compact.join("_").to_sym
  end
end
