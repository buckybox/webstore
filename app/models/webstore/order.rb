require 'draper'
require 'money'
require_relative '../webstore'

class Webstore::Order
  include Draper::Decoratable

  attr_reader :cart
  attr_reader :box

  def initialize(args = {})
    args         = defaults.merge(args)
    @money_class = args[:money_class]
    @box_class   = args[:box_class]
    @cart        = args[:cart]
    @box         = get_box(args)
    @information = {}
  end

  def add_information(new_information)
    new_information = new_information.to_h
    information.merge!(new_information)
  end

  def has_exclusions?
    !!exclusions
  end

  def exclusion_line_items
    LineItem.where(id: exclusions)
  end

  def has_substitutions?
    !!substitutions
  end

  def substitution_line_items
    LineItem.where(id: substitutions)
  end

  def has_extras?
    !!information[:extras]
  end

  def is_scheduled?
    !!information[:frequency]
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

  def total
    result = box_price
    result += extras_price if has_extras?
    result += delivery_fee if is_scheduled?
    result += bucky_fee    if has_bucky_fee?
    result += discount     if has_discount?
    result
  end

  def box_price
    OrderPrice.discounted(box.price, customer)
  end

  def extras_price
    OrderPrice.extras_price(extras_hash, customer)
  end

  def delivery_fee
    OrderPrice.discounted(route.fee, customer)
  end

  def bucky_fee
    distributor.consumer_delivery_fee
  end

  def discount
    OrderPrice.discounted(total, customer) - total
  end

  def extras_list
    box.available_extras
  end

  def add_product(product_id)
    self.box = get_box(box_id: product_id)
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

  def extras
    extra_ids = information[:extras].keys
    Extra.where(id: extra_ids)
  end

  def extra_quantity(extra)
    extra_id = extra.id
    information[:extras][extra_id]
  end

  def schedule
    @schedule ||= ScheduleBuilder.build({
      start_date:  information[:start_date],
      frequency:   information[:frequency],
      days:        information[:days],
    })
  end

  def for_halted_customer?
    customer.halted?
  end

  def has_extras?
    !!information[:extras]
  end

private

  attr_accessor :information

  attr_reader :box_class
  attr_reader :money_class

  attr_writer :box

  def defaults
    { box_class: Box, money_class: Money }
  end

  def get_box(args)
    box = box_class.new(args[:box]) if args[:box]
    box = box_class.find(args[:box_id]) if args[:box_id]
    box
  end

  def distributor
    cart ? cart.distributor : Distributor.new
  end

  def customer
    cart ? cart.customer.customer : Customer.new
  end

  def route
    route_id = information[:route_id]
    route_id ? Route.find(route_id) : Route.new
  end

  def extras_hash
    extras_hash  = extras.each_with_object({}) { |extra, hash| hash[extra] = extra_count(extra.id) }
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

  def extra_count(extra_id)
    information[:extras][extra_id]
  end

  def exclusions
    information[:likes]
  end

  def substitutions
    information[:dislikes]
  end
end
