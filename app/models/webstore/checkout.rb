require_relative 'customer'
require_relative '../webstore'

class Webstore::Checkout
  attr_reader :cart

  def initialize(args = {})
    args                = defaults.merge(args)
    @distributor        = args[:distributor]
    @logged_in_customer = args[:logged_in_customer]
    @cart               = args[:cart_class].new(customer: customer)
  end

  def customer(customer_class = Webstore::Customer)
    customer_class.new(customer: logged_in_customer, distributor: distributor)
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
  attr_reader :logged_in_customer

  def defaults
    { cart_class: Webstore::Cart }
  end
end
