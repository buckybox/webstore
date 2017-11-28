# frozen_string_literal: true

require_relative "../../app/models/order"

describe Order do
  let(:delivery_service_class) { instance_double("delivery_service_class") }
  let(:product)                { instance_double(Product) }
  let(:product_class)          { instance_double("product_class", find: product) }
  let(:cart)                   { instance_double(Cart).as_null_object }
  let(:args)                   { { cart: cart, delivery_service_class: delivery_service_class, product_class: product_class } }
  let(:order)                  { described_class.new(args) }

  describe "#extra_quantity" do
    it "returns the quantity for an extra in this order" do
      allow(order).to receive(:extras) { { 1 => 1 } }
      extra = double("extra", id: 1) # rubocop:disable RSpec/VerifiedDoubles
      expect(order.extra_quantity(extra)).to eq(1)
    end
  end

  describe "#extras_price" do
    it "returns the total price of the extras" do
      expected_array = [double("tuple1"), double("tuple2")] # rubocop:disable RSpec/VerifiedDoubles
      allow(order).to receive(:extras_as_hashes)
      order_price_class = class_double(OrderPrice, extras_price: expected_array)
      expect(order.extras_price(order_price_class)).to eq(expected_array)
    end
  end

  describe "#scheduled?" do
    it "return true if the order has a schedule" do
      allow(order).to receive(:frequency) { "single" }
      expect(order).to be_is_scheduled
    end
  end

  describe "#delivery_service_fee" do
    it "return the delivery fee" do
      allow(order).to receive(:delivery_service) { object_double("delivery_service", fee: 5) }
      expect(order.delivery_service_fee).to eq(5)
    end
  end

  describe "#has_total?" do
    it "returns true if can calculate a total" do
      allow(order).to receive(:information) { { complete: false } }
      expect(order.has_total?).to eq(true)
    end
  end

  describe "#total" do
    before do
      allow(order).to receive(:product_price)  { 10 }
      allow(order).to receive(:extras_price)   { 10 }
      allow(order).to receive(:delivery_service_fee) { 5 }
    end

    it "returns the total cost of the order" do
      expect(order.total).to eq(10 + 10 + 5)
    end
  end
end
