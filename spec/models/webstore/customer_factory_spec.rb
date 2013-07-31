require 'spec_helper'

describe Webstore::CustomerFactory do
  let(:distributor) { Fabricate(:distributor) }

  let(:customer) do
    {
      customer: nil,
      distributor: distributor,
    }
  end

  let(:box) { Fabricate(:customisable_box) }
  let(:order) do
    Webstore::Order.new(
      box: box,
      cart: nil,
      information: information_hash,
    )
  end

  let(:args) { { cart: nil, customer: customer } }

  describe "#initialize" do
    it "accepts a cart and a customer" do
      Webstore::OrderFactory.new args
    end
  end

  describe "#assemble" do
    before do
      @factory = Webstore::CustomerFactory.new(args)
      @new_customer = @factory.assemble
    end

    it "sets the right email" do
      expect(@new_customer.email).to eq(customer.email)
    end

    it "sets the right account" do
      expect(@new_customer.account).to eq(customer.account)
    end

    it "sets the right address" do
      expect(@new_customer.address).to eq(customer.address)
    end
  end
end

