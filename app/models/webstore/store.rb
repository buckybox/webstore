require_relative 'product'
require_relative 'customer'
require_relative '../webstore'

class Webstore::Store
  def initialize(args = {})
    @distributor        = args[:distributor]
    @logged_in_customer = args[:logged_in_customer]
  end

  def products(product_class = Webstore::Product)
    @products ||= product_class.build_distributors_products(distributor)
  end

  def customer(customer_class = Webstore::Customer)
    @customer ||= customer_class.new(logged_in_customer: logged_in_customer, distributor: distributor)
  end

private

  attr_reader :distributor
  attr_reader :logged_in_customer
end
