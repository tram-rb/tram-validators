RSpec.describe ValidityValidator do
  before do
    Test::Foo = Struct.new(:bar) do
      include ActiveModel::Validations
      validates :bar, presence: true
    end

    Test::Subject = Struct.new(:foo) do
      include ActiveModel::Validations
    end

    Test::Subject.validates :foo, validity: opts
  end

  subject { Test::Subject.new(value) }

  context "without key option" do
    let(:opts) { true }

    context "when value is valid per se" do
      let(:value) { Test::Foo.new(1) }
      it { is_expected.to be_valid }
    end

    context "when value is invalid per se" do
      let(:value) { Test::Foo.new(nil) }
      it { is_expected.to be_invalid_with_error :foo }
    end
  end

  context "with original_keys option" do
    let(:opts) { { original_keys: true } }

    context "when value is valid per se" do
      let(:value) { Test::Foo.new(1) }
      it { is_expected.to be_valid }
    end

    context "when value is invalid per se" do
      let(:value) { Test::Foo.new(nil) }
      it { is_expected.to be_invalid_with_error :bar }
    end
  end

  context "with nested_keys option" do
    let(:opts) { { nested_keys: true } }

    context "when value is valid per se" do
      let(:value) { Test::Foo.new(1) }
      it { is_expected.to be_valid }
    end

    context "when value is invalid per se" do
      let(:value) { Test::Foo.new(nil) }
      it { is_expected.to be_invalid_with_error "foo[bar]" }
    end
  end
end
