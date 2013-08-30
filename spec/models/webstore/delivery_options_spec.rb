require_relative '../../../app/models/webstore/delivery_options'

describe Webstore::DeliveryOptions do
  let(:distributor)      { double('distributor') }
  let(:customer)         { double('customer') }
  let(:cart)             { double('cart', distributor: distributor, customer: customer) }
  let(:args)             { { cart: cart } }
  let(:delivery_options) { Webstore::DeliveryOptions.new(args) }

  describe '#existing_delivery_service_id' do
    it 'returns a delivery_service id' do
      customer.stub(:delivery_service_id) { 3 }
      delivery_options.existing_delivery_service_id.should eq(3)
    end
  end

  describe '#can_change_delivery_service?' do
    context :existing_customer do
      it 'returns true if the there is not an existing delivery_service' do
        delivery_options.stub(:existing_delivery_service_id) { 3 }
        delivery_options.can_change_delivery_service?.should be_false
      end
    end

    context :new_customer do
      it 'returns true if the there is not an existing delivery_service' do
        delivery_options.stub(:existing_delivery_service_id) { nil }
        delivery_options.can_change_delivery_service?.should be_true
      end
    end
  end

  describe '#delivery_services' do
    it 'returns an array of delivery_services' do
      expected_delivery_services = [double('delivery_service')]
      distributor.stub(:delivery_services) { expected_delivery_services }
      delivery_options.delivery_services.should eq(expected_delivery_services)
    end
  end

  describe '#delivery_service_list' do
    it 'returns a list of delivery_service options for selection' do
      delivery_service = double('delivery_service', id: 3, name_days_and_fee: 'delivery_service wed $5.00')
      distributor.stub(:delivery_services) { [delivery_service] }

      delivery_options.delivery_service_list.should eq([["delivery_service wed $5.00", 3]])
    end
  end

  describe '#order_frequencies' do
    it 'returns a list of order frequency options' do
      expected_options = [
        ['- Select delivery frequency -', nil],
        ['Deliver weekly on...',          :weekly],
        ['Deliver every 2 weeks on...',   :fortnightly],
        ['Deliver monthly',               :monthly],
        ['Deliver once',                  :single]
      ]

      delivery_options.order_frequencies.should eq(expected_options)
    end
  end

  describe '#extra_frequencies' do
    it 'returns a list of extra frequency options' do
      expected_options = [["Include Extra Items with EVERY delivery", false], ["Include Extra Items with NEXT delivery only", true]]
      delivery_options.extra_frequencies.should eq(expected_options)
    end
  end

  describe '#dates_grid' do
    it 'returns a set of selectable dates' do
      dates_grid = [[double('date_tuple_1')], [double('date_tuple_1')]]
      delivery_dates_class = double('delivery_dates_class', dates_grid: dates_grid)
      delivery_options.dates_grid(delivery_dates_class).should eq(dates_grid)
    end
  end

  describe '#start_dates' do
    it 'returns a list of start dates' do
      start_dates = [double('date_tuple_1'), double('date_tuple_2')]
      delivery_dates_class = double('delivery_dates_class', start_dates: start_dates)
      delivery_service = double('delivery_service')
      delivery_options.start_dates(delivery_service, delivery_dates_class).should eq(start_dates)
    end
  end

  describe '#cart_has_extras' do
    it 'returns true if this cart allows extras' do
      cart.stub(:has_extras?) { true }
      delivery_options.cart_has_extras?.should be_true
    end
  end

  describe '#to_h' do
    it 'returns a hash of the important form data' do
      start_date = Date.parse('2013-02-03')
      delivery_options.delivery_service           = 3
      delivery_options.start_date      = start_date
      delivery_options.frequency       = 'single'
      delivery_options.days            = { 1 => 2 }
      delivery_options.extra_frequency = true
      delivery_options.to_h.should eq({ delivery_service_id: 3, start_date: start_date, frequency: "single", days: { 1 => 2 }, extra_frequency: true })
    end
  end
end
