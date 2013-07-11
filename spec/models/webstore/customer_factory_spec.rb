require 'spec_helper'

describe Webstore::CustomerFactory do
    let(:customer) do
      {
        customer: nil,
        distributor: nil,
      }
    end

    let(:cart) { double("Webstore::Cart", customer: customer) }

    it "accepts a cart" do
      Webstore::CustomerFactory.new cart
    end
end

