# frozen_string_literal: true

require_relative "../../../app/models/checkout/customise_order"

describe CustomiseOrder do
  let(:product)         { double("product") } # rubocop:disable RSpec/VerifiedDoubles
  let(:cart)            { instance_double(Cart, product: product) }
  let(:args)            { { cart: cart } }
  let(:customise_order) { described_class.new(args) }

  describe "#stock_list" do
    it "returns a list of stock items" do
      stock_list = [double("stock_item")] # rubocop:disable RSpec/VerifiedDoubles
      allow(cart).to receive(:stock_list) { stock_list }
      expect(customise_order.stock_list).to eq(stock_list)
    end
  end

  describe "#extras_list" do
    it "returns a list of extras items for a cart" do
      extras_list = [double("extra")] # rubocop:disable RSpec/VerifiedDoubles
      allow(cart).to receive(:extras_list) { extras_list }
      expect(customise_order.extras_list).to eq(extras_list)
    end
  end

  describe "#exclusions?" do
    specify do
      allow(product).to receive(:dislikes) { true }
      expect(customise_order.exclusions?).to be true
    end

    specify do
      allow(product).to receive(:dislikes) { false }
      expect(customise_order.exclusions?).to be false
    end
  end

  describe "#substitutions?" do
    specify do
      allow(product).to receive(:likes) { true }
      expect(customise_order.substitutions?).to be true
    end

    specify do
      allow(product).to receive(:likes) { false }
      expect(customise_order.substitutions?).to be false
    end
  end

  describe "#extras_allowed?" do
    specify do
      allow(product).to receive(:extras_allowed) { true }
      expect(customise_order.extras_allowed?).to be true
    end

    specify do
      allow(product).to receive(:extras_allowed) { false }
      expect(customise_order.extras_allowed?).to be false
    end
  end

  describe "#extras_unlimited?" do
    specify do
      allow(product).to receive(:extras_unlimited) { true }
      expect(customise_order.extras_unlimited?).to be true
    end

    specify do
      allow(product).to receive(:extras_unlimited) { false }
      expect(customise_order.extras_unlimited?).to be false
    end
  end

  describe "#exclusions_limit" do
    specify do
      allow(product).to receive(:exclusions_limit) { 5 }
      expect(customise_order.exclusions_limit).to eq(5)
    end
  end

  describe "#substitutions_limit" do
    specify do
      allow(product).to receive(:substitutions_limit) { 5 }
      expect(customise_order.substitutions_limit).to eq(5)
    end
  end

  describe "#extras_limit" do
    specify do
      allow(product).to receive(:extras_limit) { 5 }
      expect(customise_order.extras_limit).to eq(5)
    end
  end

  describe "#to_h" do
    it "returns a hash of the important form data" do
      customise_order.dislikes = [1]
      customise_order.likes    = [1]
      customise_order.extras   = { 1 => 1 }
      expect(customise_order.to_h).to eq(dislikes: [1], likes: [1], extras: { 1 => 1 })
    end
  end
end
