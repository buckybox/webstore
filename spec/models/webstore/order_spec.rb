require_relative '../../../app/models/webstore/order'

describe Webstore::Order do
  class Box; end
  class Distributor; end
  class Customer; end
  class Route; end

  let(:box)   { double('box') }
  let(:cart)  { double('cart') }
  let(:args)  { { cart: cart } }
  let(:order) { Webstore::Order.new(args) }

  before { order.stub(:get_box) { box } }

  describe '#add_product' do
    it 'adds a product to the order' do
      order.add_product(1).should eq(box)
    end
  end

  describe '#box_image' do
    it 'returns a box image' do
      box.stub(:webstore_image_url) { 'image.png' }
      order = Webstore::Order.new
      order.stub(:box) { box }
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
      order_price_class = double('order_price_class', discounted: 5)
      box.stub(:price) { 1 }
      order.box_price(order_price_class).should eq(5)
    end
  end

  describe '#has_exclusions?' do
    it 'returns true if the order has exclusions' do
      order.stub(:exclusions) { [double('exclusion')] }
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

  describe '#extras_price' do
    it 'returns the total price of the extras' do
      expected_array = [ double('tuple1'), double('tuple2') ]
      order.stub(:extras_as_hashes)
      order_price_class = double('order_price_class', extras_price: expected_array)
      order.extras_price(order_price_class).should eq(expected_array)
    end
  end

  describe '#scheduled?' do
    it 'return true if the order has a schedule' do
      order.stub(:frequency) { double('frequency') }
      order.is_scheduled?.should eq(true)
    end
  end

  describe '#schedule' do
    it 'returns the schedule for when this order should be delivered' do
      schedule = double('schedule')
      schedule_builder_class = double('schedule_builder_class', build: schedule)
      order.schedule(schedule_builder_class).should eq(schedule)
    end
  end

  describe '#delivery_fee' do
    it 'return the delivery fee' do
      order_price_class = double('order_price_class', discounted: 5)
      order.stub(:route) { double('route', fee: 5) }
      order.delivery_fee(order_price_class).should eq(5)
    end
  end

  describe '#has_bucky_fee?' do
    it 'return true if there is a bucky fee' do
      order.stub(:distributor) { double('distributor', separate_bucky_fee?: true) }
      order.has_bucky_fee?.should eq(true)
    end
  end

  describe '#bucky_fee' do
    it 'returns the bucky fee' do
      order.stub(:distributor) { double('distributor', consumer_delivery_fee: 1) }
      order.bucky_fee.should eq(1)
    end
  end

  describe '#has_total?' do
    it 'returns true if can calculate a total' do
      order.stub(:information) { { complete: false } }
      order.has_total?.should eq(true)
    end
  end

  describe '#discount' do
    it 'returns the discount on the order' do
      order_price_class = double('order_price_class', discounted: 5)
      order.stub(:total) { 3 }
      order.discount(order_price_class).should eq(2)
    end 
  end

  describe '#has_discount?' do
    it 'returns true if there is a discount on the order' do
      customer = double('customer', discount?: true)
      order.stub(:customer) { customer }
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
      order.stub(:is_scheduled?)  { false }
      order.stub(:has_bucky_fee?) { false }
      order.stub(:has_discount?)  { false }
    end

    it 'returns the total cost of the order with only box price' do
      order.total.should eq(1)
    end

    it 'returns the total cost of the order with only box price' do
      order.stub(:has_extras?) { true }
      order.total.should eq(2)
    end

    it 'returns the total cost of the order with only box price' do
      order.stub(:has_extras?)   { true }
      order.stub(:is_scheduled?) { true }
      order.total.should eq(3)
    end

    it 'returns the total cost of the order with only box price' do
      order.stub(:has_extras?)    { true }
      order.stub(:is_scheduled?)  { true }
      order.stub(:has_bucky_fee?) { true }
      order.total.should eq(4)
    end

    it 'returns the total cost of the order with only box price' do
      order.stub(:has_extras?)    { true }
      order.stub(:is_scheduled?)  { true }
      order.stub(:has_bucky_fee?) { true }
      order.stub(:has_discount?)     { true }
      order.total.should eq(5)
    end
  end
end
