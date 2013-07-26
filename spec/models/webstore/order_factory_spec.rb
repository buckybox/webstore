require 'spec_helper'

describe Webstore::OrderFactory do
  # stub data from `Webstore::CartPersistance.last.collected_data.order`
  let(:information) do
    {
      # dislikes: [646], # FIXME to test
      # likes: [652], # FIXME to test
      extras: { 156 => 2 },
      email: nil, # FIXME seems we don't capture the email?
      password: nil,
      route_id: 177,
      start_date: "Fri, 02 Aug 2013",
      frequency: "weekly",
      days: {5 => 1},
      extra_frequency: false,
      name: nil,
      phone_number: nil,
      phone_type: nil,
      street_address: nil,
      street_address_2: nil,
      suburb: nil,
      city: "Southwell",
      postcode: nil,
      delivery_note: nil,
      payment_method: "bank_deposit",
      complete: true
    }
  end

  let(:box) { Fabricate(:customisable_box) }

  let(:order) do
    Webstore::Order.new(
      box: box,
      cart: nil,
      information: information
    )
  end

  let(:cart) { double("Webstore::Cart", order: order) }
  let(:customer) { Fabricate(:customer) }
  let(:args) { { cart: cart, customer: customer } }

  describe "#initialize" do
    it "accepts a cart and a customer" do
      Webstore::OrderFactory.new args
    end
  end

  describe "#assemble" do
    before do
      @factory = Webstore::OrderFactory.new(args)
      @factory.assemble

      @new_order = @factory.order
    end

    it "has the right quantity" do
      expect(@new_order.quantity).to eq(Order::QUANTITY)
    end

    it "has the extras" do
      information[:extras].each do |id, count|
        expect(@new_order.order_extras.detect do |order_extra|
          order_extra.extra_id == id && order_extra.count == count
        end).to_not be_nil
      end
    end

    context "#schedule_rule" do
      let(:schedule_rule) { @new_order.schedule_rule }

      it "has the right start_date" do
        expect(schedule_rule.start.inspect).to eq(information[:start_date])
      end

      it "has the right frequency" do
        expect(schedule_rule.frequency.to_s).to eq(information[:frequency])
      end

      it "has the right days" do
        expect(schedule_rule.days).to eq([:fri]) # FIXME
      end
    end
  end
end
