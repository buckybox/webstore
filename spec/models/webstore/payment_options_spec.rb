require_relative '../../../app/models/webstore/payment_options'

describe Webstore::PaymentOptions do
  class Address; end
  class PhoneCollection; end
  class PaymentOption; end

  let(:address)         { double('address', 'phone=' => nil) }
  let(:address_class)   { double('address_class', new: address, address_attributes: %w()) }
  let(:customer)        { double('customer', guest?: true, existing_customer: nil) }
  let(:distributor)     { double('distributor', city: "Wellington") }
  let(:order)           { double('order', delivery_service: double(pickup_point?: false)) }
  let(:cart)            { double('cart', distributor: distributor, customer: customer, order: order) }
  let(:args)            { { cart: cart, address_class: address_class } }
  let(:payment_options) { Webstore::PaymentOptions.new(args) }

  describe '#name' do
    context 'has been passed a name attribute' do
      it 'returns the attribute value' do
        name = 'New Customer'
        new_args = args.merge({ name: name })
        payment_options = Webstore::PaymentOptions.new(new_args)
        expect(payment_options.name).to eq(name)
      end
    end

    context 'has not been passed a name attribute' do
      it 'returns the customer name' do
        allow(customer).to receive(:name) { 'Existing Customer' }
        payment_options = Webstore::PaymentOptions.new(args)
        expect(payment_options.name).to eq(customer.name)
      end
    end
  end

  describe '#existing_customer?' do
    context 'with a new customer' do
      it 'returns false' do
        allow(customer).to receive(:guest?) { true }
        expect(payment_options.existing_customer?).to be false
      end
    end

    context 'with a existing customer' do
      it 'returns true' do
        allow(customer).to receive(:address) { address }
        allow(customer).to receive(:guest?) { false }
        expect(payment_options.existing_customer?).to be true
      end
    end
  end

  describe '#only_one_payment_option?' do
    it 'returns true if there is only one payment option for this distributor' do
      allow(distributor).to receive(:only_one_payment_option?) { true }
      expect(payment_options.only_one_payment_option?).to be true
    end
  end

  describe '#collect_phone' do
    it 'returns true if the distributor requires a phone number' do
      allow(distributor).to receive(:collect_phone) { true }
      expect(payment_options.collect_phone).to be true
    end
  end

  describe '#phone_types' do
    it 'returns a list of phone number types' do
      expected_options = [double('tuple1'), double('tuple2')]
      phone_collection_class = double('phone_collection_class', types_as_options: expected_options)
      expect(payment_options.phone_types(phone_collection_class)).to eq(expected_options)
    end
  end

  describe '#require_phone' do
    it 'returns true if a phone number is required' do
      allow(distributor).to receive(:require_phone) { true }
      expect(payment_options.require_phone).to be true
    end
  end

  describe '#require_address_1' do
    it 'returns true if the first address line is required' do
      allow(distributor).to receive(:require_address_1) { true }
      expect(payment_options.require_address_1).to be true
    end
  end

  describe '#require_address_2' do
    it 'returns true if the second address line is required' do
      allow(distributor).to receive(:require_address_2) { true }
      expect(payment_options.require_address_2).to be true
    end
  end

  describe '#require_suburb' do
    it 'returns true if the suburb is required' do
      allow(distributor).to receive(:require_suburb) { true }
      expect(payment_options.require_suburb).to be true
    end
  end

  describe '#require_city' do
    it 'returns true if the city is required' do
      allow(distributor).to receive(:require_city) { true }
      expect(payment_options.require_city).to be true
    end
  end

  describe '#require_postcode' do
    it 'returns true if the postcode is required' do
      allow(distributor).to receive(:require_postcode) { true }
      expect(payment_options.require_postcode).to be true
    end
  end

  describe '#to_h' do
    it 'returns a hash of the important form data' do
      address = double('address',
        default_phone_number:  '123',
        default_phone_type:    'mobile',
        address_1:             '12 St',
        address_2:             'Apt 2',
        suburb:                'burb',
        city:                  'city',
        postcode:              '123',
        delivery_note:         'notes',
      )

      allow(customer).to receive(:guest?)         { false }
      allow(customer).to receive(:name)           { 'name' }
      allow(customer).to receive(:address)        { address }
      allow(customer).to receive(:payment_method) { 'COD' }

      payment_options.name           = 'name'
      payment_options.phone_number   = '123'
      payment_options.phone_type     = 'mobile'
      payment_options.address_1      = '12 St'
      payment_options.suburb         = 'burb'
      payment_options.city           = 'London'
      payment_options.postcode       = '123'
      payment_options.complete       = true

      expect(payment_options.to_h).to eq({ name: "name", phone_number: "123", phone_type: "mobile", address_1: "12 St", address_2: nil, suburb: "burb", postcode: "123", city: "London", delivery_note: nil, payment_method: nil, complete: true })
    end
  end
end
