require_relative 'customer'
require_relative 'cart'

class Webstore::Checkout
  attr_reader :cart

  def initialize(args = {})
    @distributor        = args[:distributor]
    @logged_in_customer = args[:logged_in_customer]
    @cart               = Webstore::Cart.new(customer: customer)
  end

  def customer(customer_class = Webstore::Customer)
    @customer ||= customer_class.new(logged_in_customer: logged_in_customer, distributor: distributor)
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
end
