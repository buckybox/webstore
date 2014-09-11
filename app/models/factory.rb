require_relative 'order_factory'
require_relative 'customer_factory'

class Factory
  attr_reader :cart
  attr_reader :customer
  attr_reader :order

  def self.assemble(args)
    webstore_factory = new(args)
    webstore_factory.assemble
  end

  def initialize(args)
    @cart = args.fetch(:cart)
  end

  def assemble
    assemble_customer
    assemble_order

    @cart.save

    self
  end

private

  def assemble_customer
    @customer = CustomerFactory.assemble(cart: @cart)
  end

  def assemble_order
    @order = OrderFactory.assemble(cart: @cart, customer: @customer)
  end
end
