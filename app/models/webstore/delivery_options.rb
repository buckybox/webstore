require_relative 'form'
require_relative '../webstore'

class Webstore::DeliveryOptions < Webstore::Form
  attribute :delivery_service, Integer
  attribute :start_date,       Date
  attribute :frequency,        String
  attribute :days,             Hash[Integer => Integer]
  attribute :extra_frequency,  Boolean

  validates_presence_of :delivery_service, :start_date, :frequency
  validates_presence_of :days, if: -> { frequency != "single" }

  ORDER_FREQUENCIES = [
    ['- Select delivery frequency -', nil],
    ['Deliver weekly on...',          :weekly],
    ['Deliver every 2 weeks on...',   :fortnightly],
    ['Deliver monthly',               :monthly],
    ['Deliver once',                  :single]
  ].freeze

  EXTRA_FREQUENCIES = [
    ['Include Extra Items with EVERY delivery',      false],
    ['Include Extra Items with NEXT delivery only',  true]
  ].freeze

  def existing_delivery_service_id
    customer.delivery_service_id
  end

  def can_change_delivery_service?
    !existing_delivery_service_id
  end

  def delivery_services
    distributor.delivery_services
  end

  def delivery_service_list
    delivery_services.map { |delivery_service| delivery_service_list_item(delivery_service) }
  end

  def order_frequencies
    ORDER_FREQUENCIES
  end

  def extra_frequencies
    EXTRA_FREQUENCIES
  end

  def dates_grid(delivery_dates_class = ::Order)
    delivery_dates_class.dates_grid
  end

  def start_dates(delivery_service, delivery_dates_class = ::Order)
    delivery_dates_class.start_dates(delivery_service)
  end

  def cart_has_extras?
    cart.has_extras?
  end

  def to_h
    {
      delivery_service_id: delivery_service,
      start_date:          start_date,
      frequency:           frequency,
      days:                days,
      extra_frequency:     extra_frequency,
    }
  end

private

  def distributor
    cart.distributor
  end

  def customer
    cart.customer
  end

  def delivery_service_list_item(delivery_service)
    [ delivery_service.name_days_and_fee, delivery_service.id ]
  end
end
