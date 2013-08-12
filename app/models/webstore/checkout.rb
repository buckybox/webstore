require_relative 'customer'
require_relative '../webstore'

class Webstore::Checkout
  attr_reader :cart

  def initialize(args = {})
    args               = defaults.merge(args)
    @existing_customer = args.fetch(:existing_customer)
    @cart              = args[:cart_class].new(
      distributor_id: args[:distributor_id],
      customer: customer_hash
    )

    cart.save
  end

  def customer
    cart.customer
  end

  def add_product!(product_id)
    cart.add_product(product_id)
    cart.save
  end

  def cart_id
    cart.id
  end

private

  attr_reader :distributor_id
  attr_reader :existing_customer

  def customer_hash
    { existing_customer_id: existing_customer && existing_customer.id }
  end

  def defaults
    { cart_class: Webstore::Cart }
  end
end
