require "active_model"

module Evil
  module Validators
    # Standard conditions to check
    CONDITIONS = {
      equal_to:                 ->(value, limit) { value == limit },
      other_than:               ->(value, limit) { value != limit },
      less_than:                ->(value, limit) { value <  limit },
      less_than_or_equal_to:    ->(value, limit) { value <= limit },
      greater_than:             ->(value, limit) { value >  limit },
      greater_than_or_equal_to: ->(value, limit) { value >= limit }
    }.freeze

    # Gets value of chained attribute
    def self.chained_value(record, chain)
      chain.to_s.split(".").inject(record) { |obj, name| obj&.send(name) }
    end

    # Provides standard key for error collected by standalone validators
    def self.error_key(source, target, nested_keys: nil, original_keys: nil, **)
      return source if     original_keys
      return target unless nested_keys
      source.to_s
            .split(/\[|\]/)
            .compact
            .inject(target) { |obj, key| "#{obj}[#{key}]" }
            .to_sym
    end

    require_relative "validators/contract_validator"
    require_relative "validators/size_validator"
    require_relative "validators/validity_validator"
  end
end
