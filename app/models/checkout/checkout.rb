require_relative '../cart'

class Checkout
  attr_reader :cart

  delegate :customer, to: :cart
  delegate :id, to: :cart, prefix: true

  def initialize(args = {})
    args               = defaults.merge(args)
    @existing_customer = args.fetch(:existing_customer)
    @cart              = args[:cart_class].new(
      webstore_id: args[:webstore_id],
      customer:    customer_hash
    )

    cart.save
  end

  def add_product!(product_id)
    cart.add_product(product_id)
    cart.save
  end

private

  attr_reader :webstore_id
  attr_reader :existing_customer

  def customer_hash
    { existing_customer_id: existing_customer && existing_customer.id }
  end

  def defaults
    { cart_class: Cart }
  end
end
