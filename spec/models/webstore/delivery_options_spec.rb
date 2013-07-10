require_relative '../../../app/models/webstore/delivery_options'

describe Webstore::DeliveryOptions do
  let(:distributor)      { double('distributor') }
  let(:customer)         { double('customer') }
  let(:cart)             { double('cart', distributor: distributor, customer: customer) }
  let(:args)             { { cart: cart } }
  let(:delivery_options) { Webstore::DeliveryOptions.new(args) }
end
