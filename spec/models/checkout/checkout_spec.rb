require_relative '../../../app/models/checkout/checkout'

describe Checkout do
  let(:webstore)           { double('webstore') }
  let(:logged_in_customer) { double('logged_in_customer') }
  let(:cart)               { double('cart').as_null_object }
  let(:cart_class)         { double('cart_class', new: cart) }
  let(:checkout)           { Checkout.new(args) }
  let(:args) do
    {
      webstore: webstore,
      logged_in_customer: logged_in_customer,
      cart_class: cart_class,
      existing_customer: nil,
    }
  end

  describe '#customer' do
    it 'returns a customer' do
      allow(cart).to receive(:customer) { logged_in_customer }
      expect(checkout.customer).to eq(logged_in_customer)
    end
  end

  describe '#add_product!' do
    it 'returns true if the product is added to the cart' do
      allow(cart).to receive(:add_product)
      expect(checkout.add_product!(3)).to be_truthy
    end
  end

  describe '#cart_id' do
    it 'returns the id of the cart' do
      allow(cart).to receive(:id) { 3 }
      expect(checkout.cart_id).to eq(3)
    end
  end
end
