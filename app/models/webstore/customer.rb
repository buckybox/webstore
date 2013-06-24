require_relative '../webstore'

class Webstore::Customer
  attr_reader :distributor
  attr_reader :customer

  GUEST_NAME   = 'Guest'
  GUEST_HALTED = false

  def initialize(args = {})
    @customer    = args.fetch(:customer, nil)
    @distributor = @customer ? @customer.distributor : args.fetch(:distributor, nil)
  end

  def fetch(key, default_value = nil)
    send(key) || default_value
  end

  def halted?
    (guest? ? GUEST_HALTED : customer.halted?)
  end

  def name
    (guest? ? GUEST_NAME : customer.name)
  end

  def guest?
    !customer
  end
end
