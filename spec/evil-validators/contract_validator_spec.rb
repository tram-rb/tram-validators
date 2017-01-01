RSpec.describe ContractValidator do
  before do
    class Test::Contract < SimpleDelegator
      include ActiveModel::Validations
      validates :bar, presence: true
    end

    Test::Subject = Struct.new(:foo) do
      include ActiveModel::Validations
    end

    Test::Subject.validates :foo, contract: { policy: Test::Contract, **opts }
  end

  subject { Test::Subject.new(double(bar: value)) }

  context "without key option" do
    let(:opts) { {} }

    context "when value satisfies contract" do
      let(:value) { 1 }
      it { is_expected.to be_valid }
    end

    context "when value breaks contract" do
      let(:value) { nil }
      it { is_expected.to be_invalid_with_error :foo }
    end
  end

  context "with original_keys option" do
    let(:opts) { { original_keys: true } }

    context "when value satisfies contract" do
      let(:value) { 1 }
      it { is_expected.to be_valid }
    end

    context "when value breaks contract" do
      let(:value) { nil }
      it { is_expected.to be_invalid_with_error :bar }
    end
  end

  context "with nested_keys option" do
    let(:opts) { { nested_keys: true } }

    context "when value satisfies contract" do
      let(:value) { 1 }
      it { is_expected.to be_valid }
    end

    context "when value breaks contract" do
      let(:value) { nil }
      it { is_expected.to be_invalid_with_error "foo[bar]" }
    end
  end
end
