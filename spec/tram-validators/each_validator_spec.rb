RSpec.describe EachValidator do
  before do
    Test::Subject = Struct.new(:list) do
      include ActiveModel::Validations
      validates :list, each: { presence: true }
    end
  end

  subject { Test::Subject.new(list) }

  context "when all elements of array satisfy validation rule" do
    let(:list) { %i(foo bar baz) }
    it { is_expected.to be_valid }
  end

  context "when some element of array breaks validation rule" do
    let(:list) { [:foo, :bar, nil] }
    it { is_expected.to be_invalid_with_error "list[2]" }
  end

  context "when value is an empty array" do
    let(:list) { [] }
    it { is_expected.to be_valid }
  end

  context "when value is nil" do
    let(:list) { :foo }
    it { is_expected.to be_valid }
  end

  context "when value is neiter nil nor an array" do
    let(:list) { :foo }
    it { is_expected.to be_valid }
  end
end
