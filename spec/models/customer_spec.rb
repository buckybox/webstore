# frozen_string_literal: true

require_relative "../../app/models/customer"

describe Customer do
  let(:cart)              { double("cart") }
  let(:existing_customer) { double("existing_customer") }
  let(:customer_class)    { double("customer_class", find: existing_customer) }
  let(:args)              { { cart: cart, existing_customer_id: 1, customer_class: customer_class } }
  let(:customer)          { Customer.new(args) }

  describe "#delivery_service_id" do
    it "returns a delivery service id", :api do
      delivery_service = double("delivery_service", id: 3)
      allow(existing_customer).to receive(:delivery_service) { delivery_service }
      expect(customer.delivery_service_id).to eq(3)
    end
  end
end
