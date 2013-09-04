require_relative "../../../app/models/webstore/customer"

describe Webstore::Customer do
  class Customer; end

  let(:cart)              { double("cart") }
  let(:existing_customer) { double("existing_customer") }
  let(:customer_class)    { double("customer_class", find: existing_customer) }
  let(:args)              { { cart: cart, existing_customer_id: 1, customer_class: customer_class } }
  let(:customer)          { Webstore::Customer.new(args) }

  describe "#delivery_service_id" do
    it "returns a delivery service id" do
      delivery_service = double("delivery_service", id: 3)
      existing_customer.stub(:delivery_service) { delivery_service }
      expect(customer.delivery_service_id).to eq(3)
    end
  end

  describe "#customer_class" do
    it "defaults to Customer if nil" do
      customer = Webstore::Customer.new(customer_class: nil)

      expect(customer.send(:customer_class)).to eq(::Customer)
    end
  end
end
