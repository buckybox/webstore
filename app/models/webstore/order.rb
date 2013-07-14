require 'draper'
require_relative '../webstore'
require_relative '../order_price'

class Webstore::Order
  include Draper::Decoratable

  attr_reader :cart
  attr_reader :box

  def initialize(args = {})
    @cart        = args[:cart]
    @box         = args[:box]
    @information = {}
    @route_class = args.fetch(:route_class, Route)
  end

  def add_product(product_id, box_class = Box)
    self.box = box_class.where(id: product_id).first
  end

  def add_information(new_information)
    new_information = new_information.to_h
    information.merge!(new_information)
  end

  def has_exclusions?
    !!exclusions
  end

  def has_substitutions?
    !!substitutions
  end

  def has_extras?
    !!extras
  end

  def is_scheduled?
    !!frequency
  end

  def has_bucky_fee?
    distributor.separate_bucky_fee?
  end

  def has_total?
    !information.empty?
  end

  def has_discount?
    customer.discount?
  end

  def for_halted_customer?
    customer.halted?
  end

  def exclusion_line_items(line_item_class = LineItem)
    line_item_class.where(id: exclusions)
  end

  def substitution_line_items(line_item_class = LineItem)
    line_item_class.where(id: substitutions)
  end

  def extras_as_objects(extra_class = Extra)
    extra_ids = extras.keys
    extra_class.where(id: extra_ids)
  end

  def total
    result = box_price
    result += extras_price if has_extras?
    result += delivery_fee if is_scheduled?
    result += bucky_fee    if has_bucky_fee?
    result += discount     if has_discount?
    result
  end

  def box_price(order_price_class = OrderPrice)
     order_price_class.discounted(box.price, real_customer)
  end

  def extras_price(order_price_class = OrderPrice)
    order_price_class.extras_price(extras_as_hashes, real_customer)
  end

  def delivery_fee(order_price_class = OrderPrice)
    order_price_class.discounted(route_fee, real_customer)
  end

  def bucky_fee
    distributor.consumer_delivery_fee
  end

  def discount(order_price_class = OrderPrice)
    order_price_class.discounted(total, real_customer) - total
  end

  def extras_list
    box.available_extras
  end

  def box_image
    box.webstore_image_url
  end

  def box_name
    box.name
  end

  def box_description
    box.description
  end

  def extra_quantity(extra)
    extra_id = extra.id
    extras[extra_id]
  end

  def schedule(schedule_builder_class = ScheduleBuilder)
    @schedule ||= schedule_builder_class.build({
      start_date:  start_date,
      frequency:   frequency,
      days:        days,
    })
  end

private

  attr_accessor :information

  attr_reader :route_class

  attr_writer :box

  def distributor
    cart ? cart.distributor : Distributor.new
  end

  def route_fee
    route = route_class.where(id: route_id).first
    route.fee if route
  end

  def customer
    cart ? cart.customer : Webstore::Customer.new
  end

  def real_customer
    customer.real_customer
  end

  def extras_as_hashes
    extras_hash  = extras_as_objects.each_with_object({}) { |extra, hash| hash[extra] = extra_quantity(extra) }
    extras_hash.map { |extra, count| extra_as_hash(extra, count) }
  end

  def extra_as_hash(extra, count)
    {
      name:         extra.name,
      unit:         extra.unit,
      price_cents:  extra.price_cents,
      currency:     extra.currency,
      count:        count
    }
  end

  def exclusions
    information[:likes]
  end

  def substitutions
    information[:dislikes]
  end

  def frequency
    information[:frequency]
  end

  def start_date
    information[:start_date]
  end

  def days
    information[:days]
  end

  def extras
    information[:extras]
  end

  def route_id
    information[:route_id]
  end
end
