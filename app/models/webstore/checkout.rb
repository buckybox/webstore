require_relative 'customer'
require_relative '../webstore'

class Webstore::Checkout
  attr_reader :cart

  def initialize(args = {})
    args               = defaults.merge(args)
    @distributor       = args[:distributor]
    @existing_customer = args[:existing_customer]
    @cart              = args[:cart_class].new(distributor: distributor)
  end

  def customer
    @cart.customer
  end

  def add_product!(product_id)
    cart.add_product(product_id)
    cart.save
  end

  def cart_id
    cart.id
  end

private

  attr_reader :distributor
  attr_reader :existing_customer

  def defaults
    { cart_class: Webstore::Cart }
  end
end
