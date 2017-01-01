require "active_model"

module Evil
  module Validators
    require_relative "validators/contract_validator"
    require_relative "validators/size_validator"

    def self.error_key(source, target, nested_keys: nil, original_keys: nil, **)
      return source if     original_keys
      return target unless nested_keys
      source.to_s
            .split(/\[|\]/)
            .compact
            .inject(target) { |obj, key| "#{obj}[#{key}]" }
            .to_sym
    end
  end
end
