# Checks that value of some attribute is valid per se
# Otherwise populates the record with the attribute's validation errors
#
# With option `original_keys: true` it copies value's errors to the record
# under their original keys, as if the [#record] had attributes of the [#value].
# Otherwise the errors are copied under the [#attribute] key.
#
# This is necessary for validation of the form models, as well as
# other decorated objects.
#
# @example Checks that user.valid? returns true
#   validates :user, validity: { nested_keys: true }
#
class ValidityValidator < ActiveModel::EachValidator
  def validate_each(record, key, value)
    if !value.respond_to? :valid?
      record.errors.add attribute, :not_validatable, model: record,
                                                     attribute: key,
                                                     value: value
    elsif !value.valid?
      Tram::Validators.copy_errors(value, record, key, :invalid, value, options)
    end
  end
end
