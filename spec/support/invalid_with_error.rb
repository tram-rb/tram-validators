RSpec::Matchers.define :be_invalid_with_error do |attribute, key|
  match do |object|
    expect(object).not_to be_valid

    expect(object.errors.messages[attribute].first)
      .to match /#{attribute}.#{key}\z/
  end
end
