require_relative '../../../app/models/webstore/authentication'

describe Webstore::Authentication < Webstore::Form do
  let(:cart)                   { double('cart') }
  let(:args)                   { { cart: cart } }
  let(:authentication) { Webstore::Authentication.new(args) }

  describe '#options' do
    it 'returns an option for authorisation' do
      expected_options = [["I'm a new customer", 'new'],["I'm a returning customer", 'returning']]
      authentication.options.should eq(expected_options)
    end
  end

  describe '#default_option' do
    it 'returns the default authorisation option' do
      authentication.default_option.should eq('new')
    end
  end

  describe '#distributor_parameter_name' do
    it 'returns the parameter name of the distributor associated with this cart' do
      cart.stub(:distributor_parameter_name) { 'distributor-name' }
      authentication.distributor_parameter_name.should eq('distributor-name')
    end
  end

  describe '#to_h' do
    it 'returns a hash of the important form data' do
      authentication.email    = 'test@example.com'
      authentication.password = 'password'
      authentication.to_h.should eq({ email: 'test@example.com' })
    end
  end
end
