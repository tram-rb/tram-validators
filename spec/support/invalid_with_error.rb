RSpec::Matchers.define :be_invalid_with_error do |key, name = nil|
  match do |object|
    expect(object).not_to be_valid

    error = object.errors.messages[key.to_sym].to_a.first
    satisfy_condition = name ? match(/\.#{name}\z/) : be_present

    expect(error).to satisfy_condition
  end
end
