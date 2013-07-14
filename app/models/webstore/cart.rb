#NOTE: Can be cleaned up with SimpleDelegator or Forwardable in std Ruby lib.

require_relative '../webstore'
require_relative 'order'
require_relative 'customer'

class Webstore::Cart
  attr_reader :id
  attr_reader :order
  attr_reader :customer

  def self.find(id, persistance_class = Webstore::CartPersistance)
    persistance = persistance_class.where(id: id).first
    instance_from_persistance(persistance)
  end

  def initialize(args = {})
    @id       = args[:id]
    @order    = new_order(args)
    @customer = new_customer(args)
  end

  def new?
    id.nil?
  end

  def ==(comparison_cart)
    if new?
      self.object_id == comparison_cart.object_id
    else
      self.id == comparison_cart.id
    end
  end

  def save(persistance_class = Webstore::CartPersistance)
    persistance = find_or_create_persistance(persistance_class)
    self.id = persistance.id
    result = persistance.update_attributes(collected_data: self)
    result
  end

  def add_product(product_id)
    order.add_product(product_id)
  end

  def distributor
    customer.distributor
  end

  def distributor_parameter_name
    customer.distributor_parameter_name
  end

  def stock_list
    distributor.line_items
  end

  def extras_list
    order.extras_list
  end

  def add_order_information(information)
    order.add_information(information)
  end

  def box
    order.box
  end

  def route
    customer.route
  end

  def has_extras?
    order.has_extras?
  end

private

  attr_writer :id

  def self.instance_from_persistance(persistance)
    persistance ? persistance.collected_data : new
  end

  def new_order(args)
    args = args.merge({ cart: self })
    args = args.fetch(:order, {})
    Webstore::Order.new(args)
  end

  def new_customer(args)
    args = args.merge({ cart: self })
    args = args.fetch(:customer, {})
    Webstore::Customer.new(args)
  end

  def find_or_create_persistance(persistance_class)
    persistance = persistance_class.find_by_id(id)
    persistance = persistance_class.create unless persistance
    persistance
  end
end
