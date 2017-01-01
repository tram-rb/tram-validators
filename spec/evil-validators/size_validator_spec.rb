RSpec.describe SizeValidator do
  before do
    Test::Subject = Struct.new(:foo, :bar, :baz) do
      include ActiveModel::Validations
    end
  end

  let(:foo) { %w(Color Size) }
  let(:bar) { double baz: 2 }
  let(:baz) { double qux: %w(Green XXXL) }

  subject { Test::Subject.new(foo, bar, baz) }

  context "equal_to number" do
    before { Test::Subject.validates :foo, size: { equal_to: 2 } }

    context "when attribute has size equal to limit" do
      let(:foo) { %w(Color Size) }
      it { is_expected.to be_valid }
    end

    context "when attribute has size less than limit" do
      let(:foo) { %w(Color) }
      it { is_expected.to be_invalid_with_error :foo, :size_equal_to }
    end

    context "when attribute has size greater than limit" do
      let(:foo) { %w(Color Size Style) }
      it { is_expected.to be_invalid_with_error :foo, :size_equal_to }
    end

    context "when attribute is not an array" do
      let(:foo) { 1 }
      it { is_expected.to be_invalid_with_error :foo, :size_equal_to }
    end
  end

  context "other_than number" do
    before { Test::Subject.validates :foo, size: { other_than: 2 } }

    context "when attribute has size equal to limit" do
      let(:foo) { %w(Color Size) }
      it { is_expected.to be_invalid_with_error :foo, :size_other_than }
    end

    context "when attribute has size less than limit" do
      let(:foo) { %w(Color) }
      it { is_expected.to be_valid }
    end

    context "when attribute has size greater than limit" do
      let(:foo) { %w(Color Size Style) }
      it { is_expected.to be_valid }
    end

    context "when attribute is not an array" do
      let(:foo) { 1 }
      it { is_expected.to be_invalid_with_error :foo, :size_other_than }
    end
  end

  context "greater_than number" do
    before { Test::Subject.validates :foo, size: { greater_than: 2 } }

    context "when attribute has size equal to limit" do
      let(:foo) { %w(Color Size) }
      it { is_expected.to be_invalid_with_error :foo, :size_greater_than }
    end

    context "when attribute has size less than limit" do
      let(:foo) { %w(Color) }
      it { is_expected.to be_invalid_with_error :foo, :size_greater_than }
    end

    context "when attribute has size greater than limit" do
      let(:foo) { %w(Color Size Style) }
      it { is_expected.to be_valid }
    end

    context "when attribute is not an array" do
      let(:foo) { 1 }
      it { is_expected.to be_invalid_with_error :foo, :size_greater_than }
    end
  end

  context "greater_than_or_equal_to number" do
    before do
      Test::Subject.validates :foo, size: { greater_than_or_equal_to: 2 }
    end

    context "when attribute has size equal to limit" do
      let(:foo) { %w(Color Size) }
      it { is_expected.to be_valid }
    end

    context "when attribute has size less than limit" do
      let(:foo) { %w(Color) }
      it do
        is_expected
          .to be_invalid_with_error :foo, :size_greater_than_or_equal_to
      end
    end

    context "when attribute has size greater than limit" do
      let(:foo) { %w(Color Size Style) }
      it { is_expected.to be_valid }
    end

    context "when attribute is not an array" do
      let(:foo) { 1 }
      it do
        is_expected
          .to be_invalid_with_error :foo, :size_greater_than_or_equal_to
      end
    end
  end

  context "less_than number" do
    before { Test::Subject.validates :foo, size: { less_than: 2 } }

    context "when attribute has size equal to limit" do
      let(:foo) { %w(Color Size) }
      it { is_expected.to be_invalid_with_error :foo, :size_less_than }
    end

    context "when attribute has size less than limit" do
      let(:foo) { %w(Color) }
      it { is_expected.to be_valid }
    end

    context "when attribute has size greater than limit" do
      let(:foo) { %w(Color Size Style) }
      it { is_expected.to be_invalid_with_error :foo, :size_less_than }
    end

    context "when attribute is not an array" do
      let(:foo) { 1 }
      it { is_expected.to be_invalid_with_error :foo, :size_less_than }
    end
  end

  context "less_than_or_equal_to number" do
    before { Test::Subject.validates :foo, size: { less_than_or_equal_to: 2 } }

    context "when attribute has size equal to limit" do
      let(:foo) { %w(Color Size) }
      it { is_expected.to be_valid }
    end

    context "when attribute has size less than limit" do
      let(:foo) { %w(Color) }
      it { is_expected.to be_valid }
    end

    context "when attribute has size greater than limit" do
      let(:foo) { %w(Color Size Style) }
      it do
        is_expected.to be_invalid_with_error :foo, :size_less_than_or_equal_to
      end
    end

    context "when attribute is not an array" do
      let(:foo) { 1 }
      it do
        is_expected.to be_invalid_with_error :foo, :size_less_than_or_equal_to
      end
    end
  end

  context "equal_to attribute" do
    before { Test::Subject.validates :foo, size: { equal_to: "bar.baz" } }

    context "when attribute has size equal to limit" do
      let(:foo) { %w(Color Size) }
      it { is_expected.to be_valid }
    end

    context "when attribute has size less than limit" do
      let(:foo) { %w(Color) }
      it do
        is_expected.to be_invalid_with_error :foo, :size_equal_to_bar_baz
      end
    end

    context "when attribute has size greater than limit" do
      let(:foo) { %w(Color Size Style) }
      it do
        is_expected.to be_invalid_with_error :foo, :size_equal_to_bar_baz
      end
    end

    context "when attribute is not an array" do
      let(:foo) { 1 }
      it do
        is_expected.to be_invalid_with_error :foo, :size_equal_to_bar_baz
      end
    end
  end

  context "other_than attribute" do
    before { Test::Subject.validates :foo, size: { other_than: "bar.baz" } }

    context "when attribute has size equal to limit" do
      let(:foo) { %w(Color Size) }
      it do
        is_expected.to be_invalid_with_error :foo, :size_other_than_bar_baz
      end
    end

    context "when attribute has size less than limit" do
      let(:foo) { %w(Color) }
      it { is_expected.to be_valid }
    end

    context "when attribute has size greater than limit" do
      let(:foo) { %w(Color Size Style) }
      it { is_expected.to be_valid }
    end

    context "when attribute is not an array" do
      let(:foo) { 1 }
      it do
        is_expected.to be_invalid_with_error :foo, :size_other_than_bar_baz
      end
    end
  end

  context "greater_than attribute" do
    before { Test::Subject.validates :foo, size: { greater_than: "bar.baz" } }

    context "when attribute has size equal to limit" do
      let(:foo) { %w(Color Size) }
      it do
        is_expected.to be_invalid_with_error :foo, :size_greater_than_bar_baz
      end
    end

    context "when attribute has size less than limit" do
      let(:foo) { %w(Color) }
      it do
        is_expected.to be_invalid_with_error :foo, :size_greater_than_bar_baz
      end
    end

    context "when attribute has size greater than limit" do
      let(:foo) { %w(Color Size Style) }
      it { is_expected.to be_valid }
    end

    context "when attribute is not an array" do
      let(:foo) { 1 }
      it do
        is_expected.to be_invalid_with_error :foo, :size_greater_than_bar_baz
      end
    end
  end

  context "greater_than_or_equal_to attribute" do
    before do
      Test::Subject.validates :foo,
                              size: { greater_than_or_equal_to: "bar.baz" }
    end

    context "when attribute has size equal to limit" do
      let(:foo) { %w(Color Size) }
      it { is_expected.to be_valid }
    end

    context "when attribute has size less than limit" do
      let(:foo) { %w(Color) }
      it do
        is_expected
          .to be_invalid_with_error :foo, :size_greater_than_or_equal_to_bar_baz
      end
    end

    context "when attribute has size greater than limit" do
      let(:foo) { %w(Color Size Style) }

      it { is_expected.to be_valid }
    end

    context "when attribute is not an array" do
      let(:foo) { 1 }
      it do
        is_expected
          .to be_invalid_with_error :foo, :size_greater_than_or_equal_to_bar_baz
      end
    end
  end

  context "less_than attribute" do
    before { Test::Subject.validates :foo, size: { less_than: "bar.baz" } }

    context "when attribute has size equal to limit" do
      let(:foo) { %w(Color Size) }
      it { is_expected.to be_invalid_with_error :foo, :size_less_than_bar_baz }
    end

    context "when attribute has size less than limit" do
      let(:foo) { %w(Color) }
      it { is_expected.to be_valid }
    end

    context "when attribute has size greater than limit" do
      let(:foo) { %w(Color Size Style) }
      it { is_expected.to be_invalid_with_error :foo, :size_less_than_bar_baz }
    end

    context "when attribute is not an array" do
      let(:foo) { 1 }
      it { is_expected.to be_invalid_with_error :foo, :size_less_than_bar_baz }
    end
  end

  context "less_than_or_equal_to attribute" do
    before do
      Test::Subject.validates :foo, size: { less_than_or_equal_to: "bar.baz" }
    end

    context "when attribute has size equal to limit" do
      let(:foo) { %w(Color Size) }
      it { is_expected.to be_valid }
    end

    context "when attribute has size less than limit" do
      let(:foo) { %w(Color) }
      it { is_expected.to be_valid }
    end

    context "when attribute has size greater than limit" do
      let(:foo) { %w(Color Size Style) }
      it do
        is_expected.to be_invalid_with_error \
          :foo, :size_less_than_or_equal_to_bar_baz
      end
    end

    context "when attribute is not an array" do
      let(:foo) { 1 }
      it do
        is_expected.to be_invalid_with_error \
          :foo, :size_less_than_or_equal_to_bar_baz
      end
    end
  end
end
