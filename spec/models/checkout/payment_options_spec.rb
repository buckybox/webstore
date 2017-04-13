# frozen_string_literal: true

require_relative "../../../app/models/checkout/payment_options"

describe PaymentOptions do
  let(:address)         { instance_double(Address, "phone=" => nil) }
  let(:address_class)   { class_double(Address, new: address, address_attributes: %w[]) }
  let(:customer)        { instance_double(Customer, guest?: true, existing_customer: nil) }
  let(:webstore)        { double("webstore", city: "Wellington") } # rubocop:disable RSpec/VerifiedDoubles
  let(:order)           { instance_double(Order, delivery_service: double(pickup_point: false)) } # rubocop:disable RSpec/VerifiedDoubles
  let(:cart)            { instance_double(Cart, webstore: webstore, customer: customer, order: order) }
  let(:args)            { { cart: cart, address_class: address_class } }
  let(:payment_options) { described_class.new(args) }

  describe "#name" do
    context "has been passed a name attribute" do
      it "returns the attribute value" do
        name = "New Customer"
        new_args = args.merge(name: name)
        payment_options = described_class.new(new_args)
        expect(payment_options.name).to eq(name)
      end
    end

    context "has not been passed a name attribute" do
      it "returns the customer name" do
        allow(customer).to receive(:name) { "Existing Customer" }
        payment_options = described_class.new(args)
        expect(payment_options.name).to eq(customer.name)
      end
    end
  end

  describe "#existing_customer?" do
    context "with a new customer" do
      it "returns false" do
        allow(customer).to receive(:guest?) { true }
        expect(payment_options.existing_customer?).to be false
      end
    end

    context "with a existing customer" do
      it "returns true" do
        allow(customer).to receive(:address) { address }
        allow(customer).to receive(:guest?) { false }
        expect(payment_options.existing_customer?).to be true
      end
    end
  end

  describe "#collect_phone" do
    it "returns true if the webstore requires a phone number" do
      allow(webstore).to receive(:collect_phone) { true }
      expect(payment_options.collect_phone).to be true
    end
  end

  describe "#phone_types" do
    it "returns a list of phone number types" do
      expected_options = [double("tuple1"), double("tuple2")] # rubocop:disable RSpec/VerifiedDoubles
      phone_collection_class = class_double(PhoneCollection, types_as_options: expected_options)
      expect(payment_options.phone_types(phone_collection_class)).to eq(expected_options)
    end
  end

  describe "#require_phone" do
    it "returns true if a phone number is required" do
      allow(webstore).to receive(:require_phone) { true }
      expect(payment_options.require_phone).to be true
    end
  end

  describe "#require_address_1" do
    it "returns true if the first address line is required" do
      allow(webstore).to receive(:require_address_1) { true }
      expect(payment_options.require_address_1).to be true
    end
  end

  describe "#require_address_2" do
    it "returns true if the second address line is required" do
      allow(webstore).to receive(:require_address_2) { true }
      expect(payment_options.require_address_2).to be true
    end
  end

  describe "#require_suburb" do
    it "returns true if the suburb is required" do
      allow(webstore).to receive(:require_suburb) { true }
      expect(payment_options.require_suburb).to be true
    end
  end

  describe "#require_city" do
    it "returns true if the city is required" do
      allow(webstore).to receive(:require_city) { true }
      expect(payment_options.require_city).to be true
    end
  end

  describe "#require_postcode" do
    it "returns true if the postcode is required" do
      allow(webstore).to receive(:require_postcode) { true }
      expect(payment_options.require_postcode).to be true
    end
  end

  describe "#to_h" do
    it "returns a hash of the important form data" do # rubocop:disable RSpec/ExampleLength
      address = instance_double(Address,
                                default_phone_number:  "123",
                                default_phone_type:    "mobile",
                                address_1:             "12 St",
                                address_2:             "Apt 2",
                                suburb:                "burb",
                                city:                  "city",
                                postcode:              "123",
                                delivery_note:         "notes")

      allow(customer).to receive(:guest?)         { false }
      allow(customer).to receive(:name)           { "name" }
      allow(customer).to receive(:address)        { address }

      payment_options.name           = "name"
      payment_options.phone_number   = "123"
      payment_options.phone_type     = "mobile"
      payment_options.address_1      = "12 St"
      payment_options.suburb         = "burb"
      payment_options.city           = "London"
      payment_options.postcode       = "123"
      payment_options.payment_method = "COD"
      payment_options.complete       = true

      expect(payment_options.to_h).to eq(
        name: "name",
        phone_number: "123",
        phone_type: "mobile",
        address_1: "12 St",
        address_2: nil,
        suburb: "burb",
        postcode: "123",
        city: "London",
        delivery_note: nil,
        payment_method: "COD",
        complete: true,
      )
    end
  end
end
