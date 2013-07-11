require_relative '../webstore'
require_relative '../customer'

class Webstore::CustomerFactory

  def initialize cart
    @cart = cart
  end

  def create_customer!
    Customer.create! customer
  end

private

  def customer
    @cart.customer
  end

end

