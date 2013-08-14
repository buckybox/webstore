require_relative '../../../app/models/webstore/payment_options'

describe Webstore::PaymentOptions do
  class Address; end
  class PhoneCollection; end
  class PaymentOption; end

  let(:address)         { double('address', 'phone=' => nil) }
  let(:address_class)   { double('address_class', new: address, address_attributes: %w()) }
  let(:customer)        { double('customer', guest?: true, existing_customer: nil) }
  let(:distributor)     { double('distributor', city: "Wellington") }
  let(:cart)            { double('cart', distributor: distributor, customer: customer) }
  let(:args)            { { cart: cart, address_class: address_class } }
  let(:payment_options) { Webstore::PaymentOptions.new(args) }

  describe '#name' do
    context 'has been passed a name attribute' do
      it 'returns the attribute value' do
        name = 'New Customer'
        new_args = args.merge({ name: name })
        payment_options = Webstore::PaymentOptions.new(new_args)
        payment_options.name.should eq(name)
      end
    end

    context 'has not been passed a name attribute' do
      it 'returns the customer name' do
        customer.stub(:name) { 'Existing Customer' }
        payment_options = Webstore::PaymentOptions.new(args)
        payment_options.name.should eq(customer.name)
      end
    end
  end

  describe '#city' do
    let(:city) { 'Wellington' }

    context 'with new customer' do
      it 'returns the distributor city' do
        customer.stub(:guest?) { true }
        distributor.stub(:city) { city }
        payment_options.city.should eq(city)
      end
    end

    context 'with existing customer' do
      it 'retuns the customer city' do
        customer.stub(:address) { address }
        customer.stub(:guest?) { false }
        address.stub(:city) { city }
        payment_options.city.should eq(city)
      end
    end
  end

  describe '#existing_customer?' do
    context 'with a new customer' do
      it 'returns false' do
        customer.stub(:guest?) { true }
        payment_options.existing_customer?.should be_false
      end
    end

    context 'with a existing customer' do
      it 'returns true' do
        customer.stub(:address) { address }
        customer.stub(:guest?) { false }
        payment_options.existing_customer?.should be_true
      end
    end
  end

  describe '#only_one_payment_option?' do
    it 'returns true if there is only one payment option for this distributor' do
      distributor.stub(:only_one_payment_option?) { true }
      payment_options.only_one_payment_option?.should be_true
    end
  end

  describe '#collect_phone?' do
    it 'returns true if the distributor requires a phone number' do
      distributor.stub(:collect_phone?) { true }
      payment_options.collect_phone?.should be_true
    end
  end

  describe '#phone_types' do
    it 'returns a list of phone number types' do
      expected_options = [double('tuple1'), double('tuple2')]
      phone_collection_class = double('phone_collection_class', types_as_options: expected_options)
      payment_options.phone_types(phone_collection_class).should eq(expected_options)
    end
  end

  describe '#payment_list' do
    it 'returns a lit of payment options' do
      expected_options = [double('tuple1'), double('tuple2')]
      payment_options_class = double('payment_options_class', options: expected_options)
      payment_options.payment_list(payment_options_class).should eq(expected_options)
    end
  end

  describe '#require_phone' do
    it 'returns true if a phone number is required' do
      distributor.stub(:require_phone) { true }
      payment_options.require_phone.should be_true
    end
  end

  describe '#require_address_1' do
    it 'returns true if the first address line is required' do
      distributor.stub(:require_address_1) { true }
      payment_options.require_address_1.should be_true
    end
  end

  describe '#require_address_2' do
    it 'returns true if the second address line is required' do
      distributor.stub(:require_address_2) { true }
      payment_options.require_address_2.should be_true
    end
  end

  describe '#require_suburb' do
    it 'returns true if the suburb is required' do
      distributor.stub(:require_suburb) { true }
      payment_options.require_suburb.should be_true
    end
  end

  describe '#require_city' do
    it 'returns true if the city is required' do
      distributor.stub(:require_city) { true }
      payment_options.require_city.should be_true
    end
  end

  describe '#require_postcode' do
    it 'returns true if the postcode is required' do
      distributor.stub(:require_postcode) { true }
      payment_options.require_postcode.should be_true
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

      customer.stub(:guest?)         { false }
      customer.stub(:name)           { 'name' }
      customer.stub(:address)        { address }
      customer.stub(:payment_method) { 'COD' }

      payment_options.name           = 'name'
      payment_options.phone_number   = '123'
      payment_options.phone_type     = 'mobile'
      payment_options.address_1      = '12 St'
      payment_options.suburb         = 'burb'
      payment_options.city           = 'London'
      payment_options.postcode       = '123'
      payment_options.complete       = true

      payment_options.to_h.should eq({ name: "name", phone_number: "123", phone_type: "mobile", address_1: "12 St", address_2: nil, suburb: "burb", postcode: "123", city: "London", delivery_note: nil, payment_method: nil, complete: true })
    end
  end
end
