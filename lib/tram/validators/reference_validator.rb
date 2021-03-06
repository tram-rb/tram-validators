# Checks that a model instance can be found by id
#
# @example Checks that AdminPolicy.new(user).valid?
#   validates :user_key, reference: { model: User, find_by: :key }
#
class ReferenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    model = options.fetch(:model) { raise "You should define :model option" }
    model = model.constantize if model.is_a? String
    key   = options.fetch(:find_by, :id)

    return if model.find_by(key => value)
    record.errors.add attribute, :not_found, model:    record,
                                             attribute: attribute,
                                             value:     value,
                                             klass:     model.name,
                                             key:       key
  end
end
