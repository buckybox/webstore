require_relative 'product'
require_relative 'customer'
require_relative '../webstore'

class Webstore::Store
  def initialize(args = {})
    @distributor       = args.fetch(:distributor)
    @existing_customer = args.fetch(:existing_customer)
  end

  def products(product_class = Webstore::Product)
    @products ||= product_class.build_distributors_products(distributor)
  end

  def customer(customer_class = Webstore::Customer)
    @customer ||= customer_class.new(
      existing_customer_id: existing_customer && existing_customer.id
    )
  end

private

  attr_reader :distributor
  attr_reader :existing_customer
end
