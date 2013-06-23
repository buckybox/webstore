require_relative '../webstore'
require_relative 'order'
require_relative 'customer'

class Webstore::Cart
  attr_reader :id
  attr_reader :order
  attr_reader :customer

  def self.find(id, persistance_class = Webstore::CartPersistance)
    persistance = persistance_class.find_by_id(id)
    attr_hash = hash_from_persistance(persistance)
    new(attr_hash)
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
    persistance.update_attributes(collected_data: self)
  end

  def add_product(args)
    order.add_product(args)
  end

private

  attr_writer :id

  def self.hash_from_persistance(persistance)
    return {} unless persistance
    hash = { id: persistance.id }
    hash.merge(persistance.collected_data)
  end

  def new_order(args)
    box_id = args[:box_id]
    default_hash = box_id ? { box_id: box_id } : {}
    Webstore::Order.new(args.fetch(:order, default_hash))
  end

  def new_customer(args)
    Webstore::Customer.new(customer: args[:customer])
  end

  def find_or_create_persistance(persistance_class)
    persistance = persistance_class.find_by_id(id)
    persistance = persistance_class.create unless persistance
    persistance
  end
end
