require 'spec_helper'

describe OrderFactory do
  include FactoryHelper

  describe "#assemble", :api do
    before do
      # pass in a real existing customer
      args[:customer] = double(:customer, id: 1)

      @factory = OrderFactory.new(args)
      @new_order = @factory.assemble
    end

    specify { expect(@new_order.completed).to be true }
    specify { expect(@new_order.active).to be true }

    it "sets the right quantity" do
      expect(@new_order.quantity).to eq(Order::QUANTITY)
    end

    it "sets the right box" do
      expect(@new_order.box).to eq(box)
    end

    it "sets the exclusions" do
      expect(@new_order.exclusions.map(&:line_item_id)).to eq(information_hash[:dislikes])
    end

    it "sets the substitutions" do
      expect(@new_order.substitutions.map(&:line_item_id)).to eq(information_hash[:likes])
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
      expect(@new_order.customer).to eq(args[:customer])
    end
  end
end
