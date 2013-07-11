require_relative '../webstore'
require_relative '../webstore/order_factory'
require_relative '../webstore/customer_factory'

class Webstore::Factory

  def initialize cart
    Webstore::OrderFactory.new cart
    Webstore::CustomerFactory.new cart
  end

end
