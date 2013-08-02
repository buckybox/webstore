require_relative 'customer'
require_relative '../webstore'

class Webstore::Checkout
  attr_reader :cart

  def initialize(args = {})
    args                = defaults.merge(args)
    @distributor        = args[:distributor]
    @existing_customer = args[:existing_customer]
    @cart               = args[:cart_class].new(customer: customer)
  end

  def customer(customer_class = Webstore::Customer)
    @customer ||= customer_class.new(existing_customer: existing_customer, distributor: distributor)
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
