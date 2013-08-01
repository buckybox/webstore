require_relative 'form'
require_relative '../webstore'

class Webstore::DeliveryOptions < Webstore::Form
  attribute :cart
  attribute :route,            Integer
  attribute :start_date,       Date
  attribute :frequency,        String
  attribute :days,             Hash[Integer => Integer]
  attribute :extra_frequency,  Boolean

  validates_presence_of :route, :start_date, :frequency, :days

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

  def existing_route_id
    customer.route_id
  end

  def can_change_route?
    !existing_route_id
  end

  def routes
    distributor.routes
  end

  def route_list
    routes.map { |route| route_list_item(route) }
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

  def start_dates(route, delivery_dates_class = ::Order)
    delivery_dates_class.start_dates(route)
  end

  def cart_has_extras?
    cart.has_extras?
  end

  def to_h
    {
      route_id:         route,
      start_date:       start_date,
      frequency:        frequency,
      days:             days,
      extra_frequency:  extra_frequency,
    }
  end

private

  def distributor
    cart.distributor
  end

  def customer
    cart.customer
  end

  def route_list_item(route)
    [ route.name_days_and_fee, route.id ]
  end
end
