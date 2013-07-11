require_relative '../webstore'
require_relative '../order'

class Webstore::OrderFactory

  def initialize cart
    @cart = cart
  end

  def create_order!
    Order.create! order
  end

private

  def order
    @cart.order
  end

end
