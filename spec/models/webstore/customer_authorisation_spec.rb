require_relative '../../../app/models/webstore/customer_authorisation'

describe Webstore::CustomerAuthorisation < Webstore::Form do
  let(:cart)                   { double('cart') }
  let(:args)                   { { cart: cart } }
  let(:customer_authorisation) { Webstore::CustomerAuthorisation.new(args) }

  describe '#options' do
    it 'returns an option for authorisation' do
      expected_options = [["I'm a new customer", 'new'],["I'm a returning customer", 'returning']]
      customer_authorisation.options.should eq(expected_options)
    end
  end

  describe '#default_option' do
    it 'returns the default authorisation option' do
      customer_authorisation.default_option.should eq('new')
    end
  end

  describe '#distributor_parameter_name' do
    it 'returns the parameter name of the distributor associated with this cart' do
      cart.stub(:distributor_parameter_name) { 'distributor-name' }
      customer_authorisation.distributor_parameter_name.should eq('distributor-name')
    end
  end

  describe '#to_h' do
    it 'returns a hash of the important form data' do
      customer_authorisation.email    = 'test@example.com'
      customer_authorisation.password = 'password'
      customer_authorisation.to_h.should eq({ email: 'test@example.com', password: 'password' })
    end
  end
end
