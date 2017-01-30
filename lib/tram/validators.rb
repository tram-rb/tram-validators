require "active_model"
require "active_support/inflector"

module Tram
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

    class << self
      # Gets value of chained attribute
      def chained_value(record, chain)
        chain.to_s.split(".").inject(record) { |obj, name| obj&.send(name) }
      end

      # Copies errors from source to target
      # if either nested or original keys selected
      def copy_errors(source, target, name, key, value, **opts)
        nested   = opts[:nested_keys]
        original = opts[:original_keys]

        if !nested && !original
          target.errors.add(name, key, record: target, value: value)
        else
          source.errors.messages.each do |k, texts|
            target_key = nested ? nested_key(name, k) : k
            texts.each { |text| target.errors.add(target_key, text) }
          end
        end
      end

      # Builds nested key
      def nested_key(target, source)
        source.to_s
              .split(/\[|\]/)
              .compact
              .reject { |key| %w(base itself).include? key.to_s }
              .inject(target) { |obj, key| "#{obj}[#{key}]" }
              .to_sym
      end

      # Extracts nested validators from options
      def validators(attr, options, *blacklist)
        options.map.with_object({}) do |(key, opts), obj|
          name = key.to_s

          next if blacklist.map(&:to_s).include? name
          next if %w(allow_nil if unless on message).include? name

          opts = {} unless opts.is_a? Hash
          obj[key] = find_validator_by_name(name).new(attributes: attr, **opts)
        end
      end

      private

      def find_validator_by_name(name)
        klass_name = "#{name.camelize}Validator"
        klass_name.constantize
      rescue
        ActiveModel::Validations.const_get(klass_name)
      end
    end

    require_relative "validators/consistency_validator"
    require_relative "validators/contract_validator"
    require_relative "validators/each_validator"
    require_relative "validators/outcome_validator"
    require_relative "validators/reference_validator"
    require_relative "validators/size_validator"
    require_relative "validators/validity_validator"
  end
end
