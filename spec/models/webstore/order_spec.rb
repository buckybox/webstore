require 'fast_spec_helper'
stub_constants %w(Box)
require_relative '../../../app/models/webstore/order'

describe Webstore::Order do
  let(:box)         { double('box') }
  let(:box_class)   { double('box_class', find: box ) }
  let(:money_class) { double('money_class') }
  let(:args)        { { id: 1, box_id: 1, box_class: box_class, money_class: money_class } }
  let(:order)       { Webstore::Order.new(args) }

  describe '.find' do
    it 'finds a customer based on an id' do
      new_order = double('order')
      Webstore::Order.stub(:new) { new_order }
      Webstore::Order.find(1).should eq(new_order)
    end
  end

  describe '#box_image' do
    it 'returns a box image' do
      box.stub(:webstore_image_url) { 'image.png' }
      order.box_image.should eq('image.png')
    end
  end

  describe '#box_name' do
    it 'returns a box name' do
      box.stub(:name) { 'box name' }
      order.box_name.should eq('box name')
    end
  end

  describe '#box_description' do
    it 'returns a box description' do
      box.stub(:description) { 'box description' }
      order.box_description.should eq('box description')
    end
  end

  describe '#box_price' do
    it 'returns a box price' do
      box.stub(:price) { 1 }
      order.box_price.should eq(1)
    end
  end

  describe '#has_exclusions?' do
    it 'returns true if the order has exclusions' do
      order.has_exclusions?.should eq(true)
    end
  end

  describe '#has_substitutions?' do
    it 'returns true if the order has substitutions' do
      order.has_substitutions?.should eq(true)
    end
  end

  describe '#has_extras?' do
    it 'returns true if the order has extras' do
      order.has_extras?.should eq(true)
    end
  end

  describe '#extras' do
    it 'returns an array of extra' do
      order.extras.should eq([])
    end
  end

  describe '#extra_quantity' do
    it 'returns the quantity for an extra in this order' do
      extra = double('extra')
      order.extra_quantity(extra).should eq(1)
    end
  end

  describe '#extra_price' do
    it 'returns the total price of the extras' do
      money_class.stub(:new) { 1 }
      order.extras_price.should eq(1)
    end
  end

  describe '#scheduled?' do
    it 'return true if the order has a schedule' do
      order.scheduled?.should eq(true)
    end
  end

  describe '#schedule' do
    it 'returns the schedule for when this order should be delivered' do
      order.schedule.should eq('Weekly')
    end
  end

  describe '#delivery_fee' do
    it 'return the delivery fee' do
      money_class.stub(:new) { 1 }
      order.discount.should eq(1)
    end
  end

  describe '#has_bucky_fee?' do
    it 'return true if there is a bucky fee' do
      order.has_bucky_fee?.should eq(true)
    end
  end

  describe '#bucky_fee' do
    it 'returns the bucky fee' do
      money_class.stub(:new) { 1 }
      order.bucky_fee.should eq(1)
    end
  end

  describe '#has_total?' do
    it 'returns true if can calculate a total' do
      order.has_total?.should eq(true)
    end
  end

  describe '#discount' do
    it 'returns the discount on the order' do
      money_class.stub(:new) { 1 }
      order.discount.should eq(1)
    end 
  end

  describe '#has_discount?' do
    it 'returns true if there is a discount on the order' do
      order.has_discount?.should eq(true)
    end
  end

  describe '#total' do
    before do
      order.stub(:box_price)      { 1 }
      order.stub(:extras_price)   { 1 }
      order.stub(:delivery_fee)   { 1 }
      order.stub(:bucky_fee)      { 1 }
      order.stub(:discount)       { 1 }
      order.stub(:has_extras?)    { false }
      order.stub(:scheduled?)     { false }
      order.stub(:has_bucky_fee?) { false }
      order.stub(:has_total?)     { false }
    end

    it 'returns the total cost of the order with only box price' do
      order.total.should eq(1)
    end

    it 'returns the total cost of the order with only box price' do
      order.stub(:has_extras?)    { true }
      order.total.should eq(2)
    end

    it 'returns the total cost of the order with only box price' do
      order.stub(:has_extras?)    { true }
      order.stub(:scheduled?)     { true }
      order.total.should eq(3)
    end

    it 'returns the total cost of the order with only box price' do
      order.stub(:has_extras?)    { true }
      order.stub(:scheduled?)     { true }
      order.stub(:has_bucky_fee?) { true }
      order.total.should eq(4)
    end

    it 'returns the total cost of the order with only box price' do
      order.stub(:has_extras?)    { true }
      order.stub(:scheduled?)     { true }
      order.stub(:has_bucky_fee?) { true }
      order.stub(:has_total?)     { true }
      order.total.should eq(5)
    end
  end
end
