require_relative 'product'
require_relative 'customer'
require_relative '../webstore'

class Webstore::Store
  def initialize(args = {})
    @distributor          = args[:distributor]
    @existing_customer_id = args[:existing_customer_id]
  end

  def products(product_class = Webstore::Product)
    @products ||= product_class.build_distributors_products(distributor)
  end

  def customer(customer_class = Webstore::Customer)
    @customer ||= customer_class.new(
      existing_customer_id: existing_customer_id,
    )
  end

private

  attr_reader :distributor
  attr_reader :existing_customer_id
end
