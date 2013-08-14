require 'spec_helper'

describe Webstore::CustomerFactory do
  include Webstore::FactoryHelper

  describe "#assemble" do
    before do
      @factory = Webstore::CustomerFactory.new(args)
      @new_customer = @factory.assemble
    end

    it "sets the right email" do
      expect(@new_customer.email).to eq(information_hash[:email])
    end

    context "#address" do
      let(:address) { @new_customer.address }

      specify { expect(address.address_1).to eq(information_hash[:address_1]) }
      specify { expect(address.address_2).to eq(information_hash[:address_2]) }
      specify { expect(address.suburb).to eq(information_hash[:suburb]) }
      specify { expect(address.city).to eq(information_hash[:city]) }
      specify { expect(address.postcode).to eq(information_hash[:postcode]) }
      specify { expect(address.delivery_note).to eq(information_hash[:delivery_note]) }
    end
  end
end

