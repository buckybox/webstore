require 'draper'
require_relative '../webstore'
require_relative '../order_price'

class Webstore::Order
  include Draper::Decoratable

  attr_reader :cart
  attr_reader :box
  attr_reader :information

  def initialize(args = {})
    @cart        = args[:cart]
    @box         = args[:box]
    @information = args[:information] || {}
    @route_class = args.fetch(:route_class, ::Route)
  end

  def add_product(product_id, box_class = ::Box)
    self.box = box_class.where(id: product_id).first
  end

  def add_information(new_information)
    new_information = new_information.to_h
    information.merge!(new_information)
  end

  def has_exclusions?
    exclusions.present?
  end

  def has_substitutions?
    substitutions.present?
  end

  def has_extras?
    extras.present?
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

  def box_price(order_price_class = ::OrderPrice)
     order_price_class.discounted(box.price, existing_customer)
  end

  def extras_price(order_price_class = ::OrderPrice)
    order_price_class.extras_price(extras_as_hashes, existing_customer)
  end

  def delivery_fee(order_price_class = ::OrderPrice)
    order_price_class.discounted(route_fee, existing_customer)
  end

  def bucky_fee
    distributor.consumer_delivery_fee
  end

  def discount(order_price_class = ::OrderPrice)
    order_price_class.discounted(total, existing_customer) - total
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

  def schedule(schedule_builder_class = ::ScheduleBuilder)
    @schedule ||= schedule_builder_class.build({
      start_date:  start_date,
      frequency:   frequency,
      days:        days,
    })
  end

  def exclusions
    information[:likes]
  end

  def substitutions
    information[:dislikes]
  end

  def extras
    information[:extras]
  end

  def extra_frequency
    information[:extra_frequency]
  end

  def payment_method
    information[:payment_method]
  end

  def customisable?
    box.customisable?
  end

private

  attr_reader :route_class

  attr_writer :box
  attr_writer :information

  def distributor
    cart ? cart.distributor : ::Distributor.new
  end

  def route
    route_class.where(id: route_id).first
  end

  def customer
    cart ? cart.customer : Webstore::Customer.new
  end

  def route_fee
    route.fee if route
  end

  def existing_customer
    cart ? cart.existing_customer : nil
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

  def frequency
    information[:frequency]
  end

  def start_date
    information[:start_date]
  end

  def days
    information[:days]
  end

  def route_id
    information[:route_id]
  end
end
