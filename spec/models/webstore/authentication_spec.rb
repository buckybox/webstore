require_relative '../../../app/models/webstore/authentication'

describe Webstore::Authentication < Webstore::Form do
  let(:cart)                   { double('cart') }
  let(:args)                   { { cart: cart } }
  let(:authentication) { Webstore::Authentication.new(args) }

  describe '#options' do
    it 'returns an option for authorisation' do
      expected_options = [["I'm a new customer", 'new'],["I'm a returning customer", 'returning']]
      expect(authentication.options).to eq(expected_options)
    end
  end

  describe '#default_option' do
    it 'returns the default authorisation option' do
      expect(authentication.default_option).to eq('new')
    end
  end

  describe '#distributor_parameter_name' do
    it 'returns the parameter name of the distributor associated with this cart' do
      allow(cart).to receive(:distributor_parameter_name) { 'distributor-name' }
      expect(authentication.distributor_parameter_name).to eq('distributor-name')
    end
  end

  describe '#to_h' do
    it 'returns a hash of the important form data' do
      authentication.email    = 'test@example.com'
      authentication.password = 'password'
      expect(authentication.to_h).to eq({ email: 'test@example.com' })
    end
  end
end
