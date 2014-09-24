require_relative '../../../app/models/store'

describe Store do
  let(:distributor) { double('distributor') }
  let(:logged_in_customer) { double('logged_in_customer') }
  let(:store) { Store.new(args) }
  let(:args) do
    {
      distributor: distributor,
      logged_in_customer: logged_in_customer,
      existing_customer: nil,
    }
  end

  class Product; end
  class Customer; end

  describe '#products' do
    it 'returns an array of products' do
      products = [double('products')]
      product_class = double('product_class', build_distributors_products: products)
      expect(store.products(product_class)).to eq(products)
    end
  end

  describe '#customer' do
    it 'returns a webstore customer' do
      customer = double('customer')
      customer_class = double('customer_class', new: customer)
      expect(store.customer(customer_class)).to eq(customer)
    end
  end
end
