require_relative '../webstore'
require_relative '../webstore/order_factory'
require_relative '../webstore/customer_factory'

class Webstore::Factory
  def self.assemble(args)
    webstore_factory = new(args)
    webstore_factory.assemble
  end

  def initialize(args)
    @cart = args[:cart]
  end

  def assemble
    customer = assemble_customer
    assemble_order(customer)
  end

private

  attr_reader :cart

  def assemble_customer
    Webstore::CustomerFactory.assemble(cart: cart)
  end

  def assemble_order(customer)
    Webstore::OrderFactory.assemble(cart: cart, customer: customer)
  end
end
