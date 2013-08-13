require_relative '../webstore'
require_relative '../webstore/order_factory'
require_relative '../webstore/customer_factory'

class Webstore::Factory
  attr_reader :cart
  attr_reader :customer
  attr_reader :order

  def self.assemble(args)
    webstore_factory = new(args)
    webstore_factory.assemble
  end

  def initialize(args)
    @cart = args.fetch(:cart)
    raise "cart customer is nil" if @cart.customer.nil?
    raise "cart order is nil" if @cart.order.nil?
  end

  def assemble
    assemble_customer
    assemble_order
    @cart.save
    self
  end

private

  def assemble_customer
    @customer = Webstore::CustomerFactory.assemble(cart: @cart)
  end

  def assemble_order
    @order = Webstore::OrderFactory.assemble(cart: @cart, customer: @customer)
  end
end
