RSpec.describe OutcomeValidator do
  before do
    Test::Subject = Struct.new(:foo, :bar) do
      include ActiveModel::Validations
      validates :foo, outcome: { value: "bar.baz", presence: true }
    end
  end

  subject { Test::Subject.new(1, bar) }

  context "when outcome is valid" do
    let(:bar) { double baz: 1 }
    it { is_expected.to be_valid }
  end

  context "when outcome is invalid" do
    let(:bar) { double baz: nil }
    it { is_expected.to be_invalid_with_error :foo, :"bar_baz_presence" }
  end

  context "when outcome produces nil inside chain" do
    let(:bar) { nil }
    it "uses nil outcome" do
      expect(subject).to be_invalid_with_error :foo, :"bar_baz_presence"
    end
  end
end
