require_relative "../../../app/models/webstore/order"

describe Webstore::Order do
  class Box; end
  class Distributor; end
  class Customer; end
  class DeliveryService; end

  let(:product) { double("product") }
  let(:cart)    { double("cart").as_null_object }
  let(:args)    { { cart: cart } }
  let(:order) do
    order = Webstore::Order.new(args)

    order.stub(:product_class) do
      double("product_class", find: product)
    end

    order
  end

  describe "#product_image" do
    it "returns a product image" do
      product.stub(:webstore_image_url) { "image.png" }
      order = Webstore::Order.new(cart: nil)
      order.stub(:product) { product }
      order.product_image.should eq("image.png")
    end
  end

  describe "#product_name" do
    it "returns a product name" do
      product.stub(:name) { "product name" }
      order.product_name.should eq("product name")
    end
  end

  describe "#product_description" do
    it "returns a product description" do
      product.stub(:description) { "product description" }
      order.product_description.should eq("product description")
    end
  end

  describe "#product_price" do
    it "returns a product price" do
      order_price_class = double("order_price_class", discounted: 5)
      product.stub(:price) { 1 }
      order.product_price(order_price_class).should eq(5)
    end
  end

  describe "#extra_quantity" do
    it "returns the quantity for an extra in this order" do
      order.stub(:extras) { {1 => 1} }
      extra = double("extra", id: 1)
      order.extra_quantity(extra).should eq(1)
    end
  end

  describe "#extras_price" do
    it "returns the total price of the extras" do
      expected_array = [ double("tuple1"), double("tuple2") ]
      order.stub(:extras_as_hashes)
      order_price_class = double("order_price_class", extras_price: expected_array)
      order.extras_price(order_price_class).should eq(expected_array)
    end
  end

  describe "#scheduled?" do
    it "return true if the order has a schedule" do
      order.stub(:frequency) { double("frequency") }
      order.is_scheduled?.should eq(true)
    end
  end

  describe "#schedule" do
    it "returns the schedule for when this order should be delivered" do
      schedule = double("schedule")
      schedule_builder_class = double("schedule_builder_class", build: schedule)
      order.schedule(schedule_builder_class).should eq(schedule)
    end
  end

  describe "#delivery_fee" do
    it "return the delivery fee" do
      order_price_class = double("order_price_class", discounted: 5)
      order.stub(:delivery_service) { double("delivery_service", fee: 5) }
      order.delivery_fee(order_price_class).should eq(5)
    end
  end

  describe "#has_bucky_fee?" do
    it "return true if there is a bucky fee" do
      order.stub(:distributor) { double("distributor", separate_bucky_fee?: true) }
      order.has_bucky_fee?.should eq(true)
    end
  end

  describe "#bucky_fee" do
    it "returns the bucky fee" do
      order.stub(:distributor) { double("distributor", consumer_delivery_fee: 1) }
      order.bucky_fee.should eq(1)
    end
  end

  describe "#has_total?" do
    it "returns true if can calculate a total" do
      order.stub(:information) { { complete: false } }
      order.has_total?.should eq(true)
    end
  end

  describe "#total" do
    before do
      order.stub(:product_price)  { 1 }
      order.stub(:extras_price)   { 1 }
      order.stub(:delivery_fee)   { 1 }
      order.stub(:bucky_fee)      { 1 }
      order.stub(:discount)       { 1 }
      order.stub(:has_extras?)    { false }
      order.stub(:is_scheduled?)  { false }
      order.stub(:has_bucky_fee?) { false }
      order.stub(:has_discount?)  { false }
    end

    it "returns the total cost of the order with only product price" do
      order.total.should eq(1)
    end

    it "returns the total cost of the order with only product price" do
      order.stub(:has_extras?) { true }
      order.total.should eq(2)
    end

    it "returns the total cost of the order with only product price" do
      order.stub(:has_extras?)   { true }
      order.stub(:is_scheduled?) { true }
      order.total.should eq(3)
    end

    it "returns the total cost of the order with only product price" do
      order.stub(:has_extras?)    { true }
      order.stub(:is_scheduled?)  { true }
      order.stub(:has_bucky_fee?) { true }
      order.total.should eq(4)
    end

    it "returns the total cost of the order with only product price" do
      order.stub(:has_extras?)    { true }
      order.stub(:is_scheduled?)  { true }
      order.stub(:has_bucky_fee?) { true }
      order.stub(:has_discount?)     { true }
      order.total.should eq(5)
    end
  end
end
