require 'spec_helper'

describe Webstore::OrderFactory do
  let(:box) { Fabricate(:customisable_box) }
  let(:exclusion) { Fabricate(:exclusion) }
  let(:substitution) { Fabricate(:substitution) }

  let!(:cart) do
    Webstore::Cart.new(
      customer: Webstore::Customer.new(
        cart: nil,
        customer: nil,
        distributor: Distributor.new
      ),
      order: {
        box: box,
        cart: nil,
        information: {
          :dislikes=>[
            exclusion.id
          ],
          :likes=>[
            substitution.id
          ],
          :extras=> {
            box.extras[0].id => 2,
            box.extras[1].id => 3,
          },
          :email=>"test@example.net",
          :password=>"",
          :route_id=>1,
          :start_date=>"Fri, 02 Aug 2013",
          :frequency=>"weekly",
          :days=>{2=>1, 5=>1},
          :extra_frequency=>false,
          :name=>"Bob",
          :phone_number=>nil, # FIXME
          :phone_type=>nil, # FIXME
          :street_address=>"Street 1",
          :street_address_2=>"",
          :suburb=>"",
          :city=>"Southwell",
          :postcode=>"",
          :delivery_note=>"",
          :payment_method=>"bank_deposit",
          :complete=>true
        }
      }
    )
  end

  let(:customer) { Fabricate.build(:customer) }
  let(:args) { { cart: cart, customer: customer } }

  let!(:information_hash) { cart.order.information }

  describe "#initialize" do
    it "accepts a cart and a customer" do
      Webstore::OrderFactory.new args
    end
  end

  describe "#assemble", focus: true do
    before do
      @factory = Webstore::OrderFactory.new(args)
      @new_order = @factory.assemble
    end

    specify { expect(@new_order.completed).to be_true }
    specify { expect(@new_order.active).to be_true }

    it "sets the right quantity" do
      expect(@new_order.quantity).to eq(Order::QUANTITY)
    end

    it "sets the right box" do
      expect(@new_order.box).to eq(box)
    end

    xit "sets the right route" do
      expect(@new_order.route.id).to eq(information_hash[:route_id])
    end

    it "sets the exclusions" do
      expect(@new_order.exclusions).to eq([exclusion])
    end

    it "sets the substitutions" do
      expect(@new_order.substitutions).to eq([substitution])
    end

    it "sets the extras" do
      information_hash[:extras].each do |id, count|
        order_extra = @new_order.order_extras.detect do |oe|
          oe.extra_id == id && oe.count == count
        end

        expect(order_extra).to_not be_nil
      end
    end

    context "#schedule_rule" do
      let(:schedule_rule) { @new_order.schedule_rule }

      it "sets the right start_date" do
        expect(schedule_rule.start.inspect).to eq(information_hash[:start_date])
      end

      it "sets the right frequency" do
        expect(schedule_rule.frequency.to_s).to eq(information_hash[:frequency])
      end

      it "sets the right days" do
        expect(schedule_rule.days).to eq([:tue, :fri])
      end
    end

    it "sets the right customer" do
      expect(@new_order.customer).to eq(customer)
    end
  end
end
