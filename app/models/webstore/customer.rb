#NOTE: Can be cleaned up with SimpleDelegator or Forwardable in std Ruby lib.

require_relative '../webstore'

class Webstore::Customer
  attr_reader :distributor
  attr_reader :customer
  attr_reader :cart

  GUEST_HALTED     = false
  GUEST_DISCOUNTED = false
  GUEST_ACTIVE     = false
  GUEST_NAME       = 'Guest'

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

  def discount?
    ( guest? ? GUEST_DISCOUNTED : customer.discount? )
  end

  def active?
    ( guest? ? GUEST_ACTIVE : customer.active? )
  end

  def name
    ( guest? ? GUEST_NAME : customer.name )
  end

  def distributor_parameter_name
    distributor.parameter_name
  end

  def route_id
    customer.route.id if active?
  end

  def address
    guest? ? NullObject.new : customer.address
  end

  def real_customer
    customer
  end
end
