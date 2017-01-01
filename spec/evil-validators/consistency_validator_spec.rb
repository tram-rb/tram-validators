RSpec.describe ConsistencyValidator do
  before do
    Test::Subject = Struct.new(:foo, :bar) do
      include ActiveModel::Validations
    end

    Test::Subject.validates :foo, consistency: options
  end

  subject { Test::Subject.new(foo, double(baz: 2)) }

  context "equal_to attribute" do
    let(:options) { { equal_to: "bar.baz" } }

    context "when attribute equals to limit" do
      let(:foo) { 2 }
      it { is_expected.to be_valid }
    end

    context "when attribute is less than limit" do
      let(:foo) { 1 }
      it { is_expected.to be_invalid_with_error :foo, :equal_to_bar_baz }
    end

    context "when attribute is greater than limit" do
      let(:foo) { 3 }
      it { is_expected.to be_invalid_with_error :foo, :equal_to_bar_baz }
    end
  end

  context "other_than attribute" do
    let(:options) { { other_than: "bar.baz" } }

    context "when attribute equals to limit" do
      let(:foo) { 2 }
      it { is_expected.to be_invalid_with_error :foo, :other_than_bar_baz }
    end

    context "when attribute is less than limit" do
      let(:foo) { 1 }
      it { is_expected.to be_valid }
    end

    context "when attribute is greater than limit" do
      let(:foo) { 3 }
      it { is_expected.to be_valid }
    end
  end

  context "greater_than attribute" do
    let(:options) { { greater_than: "bar.baz" } }

    context "when attribute equals to limit" do
      let(:foo) { 2 }
      it { is_expected.to be_invalid_with_error :foo, :greater_than_bar_baz }
    end

    context "when attribute is less than limit" do
      let(:foo) { 1 }
      it { is_expected.to be_invalid_with_error :foo, :greater_than_bar_baz }
    end

    context "when attribute is greater than limit" do
      let(:foo) { 3 }
      it { is_expected.to be_valid }
    end
  end

  context "greater_than_or_equal_to attribute" do
    let(:options) { { greater_than_or_equal_to: "bar.baz" } }

    context "when attribute equals to limit" do
      let(:foo) { 2 }
      it { is_expected.to be_valid }
    end

    context "when attribute is less than limit" do
      let(:foo) { 1 }
      it do
        is_expected.to be_invalid_with_error \
          :foo, :greater_than_or_equal_to_bar_baz
      end
    end

    context "when attribute is greater than limit" do
      let(:foo) { 3 }
      it { is_expected.to be_valid }
    end
  end

  context "less_than attribute" do
    let(:options) { { less_than: "bar.baz" } }

    context "when attribute equals to limit" do
      let(:foo) { 2 }
      it { is_expected.to be_invalid_with_error :foo, :less_than_bar_baz }
    end

    context "when attribute is less than limit" do
      let(:foo) { 1 }
      it { is_expected.to be_valid }
    end

    context "when attribute is greater than limit" do
      let(:foo) { 3 }
      it { is_expected.to be_invalid_with_error :foo, :less_than_bar_baz }
    end
  end

  context "less_than_or_equal_to attribute" do
    let(:options) { { less_than_or_equal_to: "bar.baz" } }

    context "when attribute equals to limit" do
      let(:foo) { 2 }
      it { is_expected.to be_valid }
    end

    context "when attribute is less than limit" do
      let(:foo) { 1 }
      it { is_expected.to be_valid }
    end

    context "when attribute is greater than limit" do
      let(:foo) { 3 }
      it do
        is_expected.to be_invalid_with_error \
          :foo, :less_than_or_equal_to_bar_baz
      end
    end
  end
end
