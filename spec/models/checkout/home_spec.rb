require_relative '../../../app/models/checkout/home'

describe Home do
  let(:webstore) { double('webstore') }
  let(:logged_in_customer) { double('logged_in_customer') }
  let(:home) { Home.new(args) }
  let(:args) do
    {
      webstore: webstore,
      logged_in_customer: logged_in_customer,
      existing_customer: nil,
    }
  end

  describe '#products' do
    it 'returns an array of products' do
      products = [double('products')]
      product_class = double('product_class', build_webstore_products: products)
      expect(home.products(product_class)).to eq(products)
    end
  end

  describe '#customer' do
    it 'returns a webstore customer' do
      customer = double('customer')
      customer_class = double('customer_class', new: customer)
      expect(home.customer(customer_class)).to eq(customer)
    end
  end
end
