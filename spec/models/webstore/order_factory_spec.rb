require 'spec_helper'

describe Webstore::OrderFactory do

  let(:order) do
    {
      box: nil,
      box_class: Box,
      information: {},
      money_class: Money,
    }
  end

  let(:cart) { double("Webstore::Cart", order: order) }

  describe "#initialize" do
    it "accepts a cart" do
      Webstore::OrderFactory.new cart
    end
  end

  describe "#create_order!" do
    it "creates an order from the cart" do
      factory = Webstore::OrderFactory.new cart
      new_order = factory.create_order!

      new_order.information.should eq order.information
      # ...
    end
  end
end
