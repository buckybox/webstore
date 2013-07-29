require_relative '../../../app/models/webstore/checkout'

describe Webstore::Checkout do
  let(:distributor)        { double('distributor') }
  let(:logged_in_customer) { double('logged_in_customer') }
  let(:cart)               { double('cart') }
  let(:cart_class)         { double('cart_class', new: cart) }
  let(:args)               { { distributor: distributor, logged_in_customer: logged_in_customer, cart_class: cart_class } }
  let(:checkout)           { Webstore::Checkout.new(args) }

  class Webstore::Cart; end

  describe '#customer' do
    it 'returns a customer' do
      customer_class = double('customer_class', new: logged_in_customer)
      checkout.customer(customer_class).should eq(logged_in_customer)
    end
  end

  describe '#add_product!' do
    it 'returns true if the product is added to the cart' do
      cart.stub(:add_product)
      cart.stub(:save) { true }
      checkout.add_product!(3).should be_true
    end
  end

  describe '#cart_id' do
    it 'returns the id of the cart' do
      cart.stub(:id) { 3 }
      checkout.cart_id.should eq(3)
    end
  end
end
