require_relative '../webstore'

class Webstore::Customer
  attr_reader :distributor
  attr_reader :customer
  attr_reader :cart

  GUEST_NAME   = 'Guest'
  GUEST_HALTED = false
  GUEST_ACTIVE = false

  def initialize(args = {})
    @cart        = args.fetch(:cart, nil)
    @customer    = args.fetch(:customer, nil)
    @distributor = @customer ? @customer.distributor : args.fetch(:distributor, nil)
  end

  def guest?
    !customer
  end

  def fetch(key, default_value = nil)
    send(key) || default_value
  end

  def halted?
    ( guest? ? GUEST_HALTED : customer.halted? )
  end

  def name
    ( guest? ? GUEST_NAME : customer.name )
  end

  def active?
    ( guest? ? GUEST_ACTIVE : customer.active? )
  end

  def distributor_parameter_name
    distributor.parameter_name
  end

  def route_id
    customer.route.id unless active?
  end
end
