require_relative '../../../app/models/webstore/store'

describe Webstore::Store do
  let(:distributor) { double('distributor') }
  let(:logged_in_customer) { double('logged_in_customer') }
  let(:args) { { distributor: distributor, logged_in_customer: logged_in_customer } }
  let(:store) { Webstore::Store.new(args) }

  class Webstore::Product; end
  class Webstore::Customer; end

  describe '#products' do
    it 'returns an array of products' do
      products = [double('products')]
      product_class = double('product_class', build_distributors_products: products)
      store.products(product_class).should eq(products)
    end
  end

  describe '#customer' do
    it 'returns a webstore customer' do
      customer = double('customer')
      customer_class = double('customer_class', new: customer)
      store.customer(customer_class).should eq(customer)
    end
  end
end
