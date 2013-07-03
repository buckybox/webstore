require_relative 'form'
require_relative '../webstore'

class Webstore::DeliveryOptions < Webstore::Form
  attribute :cart
  attribute :route
  attribute :extra_frequency,  Boolean
  attribute :start_date,       Date
  attribute :frequency,        String
  attribute :days,             Hash[Integer => Integer]

  def existing_route_id
    # customer used route if active where
    # active_orders = current_customer.present? && !current_customer.orders.active.count.zero?
    #current_customer.route if active_orders
    0
  end

  def can_change_route?
    !!existing_route_id
  end

  def routes
    distributor_routes = distributor.routes
    Webstore::RouteDecorator.decorate_collection(distributor_routes)
  end

  def route_list
    distributor.routes.map { |route| route_list_item(route) }
  end

  def order_frequencies
    [
      ['Deliver weekly on...', :weekly],
      ['Deliver every 2 weeks on...', :fortnightly],
      ['Deliver monthly', :monthly],
      ['Deliver once', :single]
    ]
  end

  def extra_frequencies
    [
      ['Include Extra Items with EVERY delivery', false],
      ['Include Extra Items with NEXT delivery only', true]
    ]
  end

  def dates_grid
    ::Order.dates_grid
  end

  def start_dates(route)
    ::Order.start_dates(route)
  end

  def cart_has_extras?
    #webstore_order.box.extras_allowed? && webstore_order.extras.present?
    true
  end

private

  def distributor
    cart.distributor
  end

  def route_list_item(route)
    [ route.name_days_and_fee, route.id ]
  end
end
