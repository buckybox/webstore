require_relative "../../../app/models/webstore/order"

describe Webstore::Order do
  class DeliveryService; end
  class Box; end
  class Distributor; end
  class Customer; end

  let(:delivery_service)       { double("delivery_service") }
  let(:delivery_service_class) { double("delivery_service_class") }
  let(:product)                { double("product") }
  let(:product_class)          { double("product_class", find: product) }
  let(:cart)                   { double("cart").as_null_object }
  let(:args)                   { { cart: cart, delivery_service_class: delivery_service_class, product_class: product_class } }
  let(:order)                  { Webstore::Order.new(args) }

  describe "#product_image" do
    it "returns a product image" do
      allow(product).to receive(:webstore_image_url) { "image.png" }
      order = Webstore::Order.new(cart: nil)
      allow(order).to receive(:product) { product }
      expect(order.product_image).to eq("image.png")
    end
  end

  describe "#product_name" do
    it "returns a product name" do
      allow(product).to receive(:name) { "product name" }
      expect(order.product_name).to eq("product name")
    end
  end

  describe "#product_description" do
    it "returns a product description" do
      allow(product).to receive(:description) { "product description" }
      expect(order.product_description).to eq("product description")
    end
  end

  describe "#product_price" do
    it "returns a product price" do
      order_price_class = double("order_price_class", discounted: 5)
      allow(product).to receive(:price) { 1 }
      expect(order.product_price(order_price_class)).to eq(5)
    end
  end

  describe "#extra_quantity" do
    it "returns the quantity for an extra in this order" do
      allow(order).to receive(:extras) { {1 => 1} }
      extra = double("extra", id: 1)
      expect(order.extra_quantity(extra)).to eq(1)
    end
  end

  describe "#extras_price" do
    it "returns the total price of the extras" do
      expected_array = [ double("tuple1"), double("tuple2") ]
      allow(order).to receive(:extras_as_hashes)
      order_price_class = double("order_price_class", extras_price: expected_array)
      expect(order.extras_price(order_price_class)).to eq(expected_array)
    end
  end

  describe "#scheduled?" do
    it "return true if the order has a schedule" do
      allow(order).to receive(:frequency) { double("frequency") }
      expect(order.is_scheduled?).to eq(true)
    end
  end

  describe "#schedule" do
    it "returns the schedule for when this order should be delivered" do
      schedule = double("schedule")
      schedule_builder_class = double("schedule_builder_class", build: schedule)
      expect(order.schedule(schedule_builder_class)).to eq(schedule)
    end
  end

  describe "#delivery_service_fee" do
    it "return the delivery fee" do
      allow(order).to receive(:delivery_service) { double("delivery_service", fee: 5) }
      expect(order.delivery_service_fee).to eq(5)
    end
  end

  describe "#has_bucky_fee?" do
    it "return true if there is a bucky fee" do
      allow(order).to receive(:distributor) { double("distributor", separate_bucky_fee?: true) }
      expect(order.has_bucky_fee?).to eq(true)
    end
  end

  describe "#bucky_fee" do
    it "returns the bucky fee" do
      allow(order).to receive(:distributor) { double("distributor", consumer_delivery_fee: 1) }
      expect(order.bucky_fee).to eq(1)
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
      allow(order).to receive(:bucky_fee)      { 1 }
    end

    it "returns the total cost of the order" do
      expect(order.total).to eq(10 + 10 + 5 + 1)
    end
  end

  describe "#delivery_service" do
    it "returns nil if there is no delivery service found" do
      allow(delivery_service_class).to receive(:find_by) { nil }
      expect(order.delivery_service).to be_nil
    end

    it "returns a delivery service if one is found" do
      allow(delivery_service_class).to receive(:find_by) { delivery_service }
      expect(order.delivery_service).to eq(delivery_service)
    end
  end
end
