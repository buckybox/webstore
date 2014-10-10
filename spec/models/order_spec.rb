require_relative "../../app/models/order"

describe Order do
  let(:delivery_service)       { double("delivery_service") }
  let(:delivery_service_class) { double("delivery_service_class") }
  let(:product)                { double("product") }
  let(:product_class)          { double("product_class", find: product) }
  let(:cart)                   { double("cart").as_null_object }
  let(:args)                   { { cart: cart, delivery_service_class: delivery_service_class, product_class: product_class } }
  let(:order)                  { Order.new(args) }

  describe "#product_name" do
    it "returns a product name", :api do
      allow(product).to receive(:name) { "product name" }
      expect(order.product_name).to eq("product name")
    end
  end

  describe "#product_description" do
    it "returns a product description", :api do
      allow(product).to receive(:description) { "product description" }
      expect(order.product_description).to eq("product description")
    end
  end

  describe "#product_price" do
    it "returns a product price", :api do
      order_price_class = double("order_price_class", discounted: 5)
      allow(product).to receive(:price) { 1 }
      expect(order.product_price(order_price_class)).to eq(5)
    end
  end

  describe "#extra_quantity" do
    it "returns the quantity for an extra in this order" do
      allow(order).to receive(:extras) { { 1 => 1 } }
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
      schedule_builder_class = double("schedule_builder_class", new: schedule)
      expect(order.schedule(schedule_builder_class)).to eq(schedule)
    end
  end

  describe "#delivery_service_fee" do
    it "return the delivery fee" do
      allow(order).to receive(:delivery_service) { double("delivery_service", fee: 5) }
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
