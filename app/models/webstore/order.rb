require 'draper'
require 'money'
require_relative '../webstore'

class Webstore::Order
  include Draper::Decoratable

  def initialize(args = {})
    args         = defaults.merge(args)
    @money_class = args[:money_class]
    @box_class   = args[:box_class]
    @box         = get_box(args)
    @information = []
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

  def box_price
    box.price #OrderPrice.discounted(box.price, customer)
  end

  def has_exclusions?
    true #!exclusions.empty?
  end

  def has_substitutions?
    true #!substitutions.empty?
  end

  def has_extras?
    true #!extras.empty?
  end

  def extras
    [] #Extra.find_all_by_id(extras.map(&:first))
  end

  def extra_quantity(extra)
    1 #extras[extra_object.id.to_s]
  end

  def extras_price
    money_class.new(0)
    #order_extra_hash = extras.map do |id, count|
      #extra_object = extra_objects.find{ |extra| extra.id == id.to_i }
      #{
        #name: extra_object.name,
        #unit: extra_object.unit,
        #price_cents: extra_object.price_cents,
        #currency: extra_object.currency,
        #count: count
      #}
    #end

    #@order_extras_price_mem = OrderPrice.extras_price(order_extra_hash, customer)
  end

  def scheduled?
    true
  end

  def schedule
    'Weekly' #schedule_rule
  end

  def delivery_fee
    money_class.new(0) #OrderPrice.discounted(route.fee, customer)
  end

  def has_bucky_fee?
    true #distributor.separate_bucky_fee?
  end

  def bucky_fee
    money_class.new(0) #distributor.consumer_delivery_fee
  end

  def has_total?
    true #order.customised? || order.scheduled?
  end

  def discount
    money_class.new(0) #OrderPrice.discounted(total, current_customer) - total
  end

  def has_discount?
    true
  end

  def total
    #Money.new(0, order.currency)
    result = box_price
    result += extras_price if has_extras?
    result += delivery_fee if scheduled?
    result += bucky_fee    if has_bucky_fee?
    result += discount     if has_total?
    result
  end

  def add_information(information)
    @information << information
  end

private

  attr_accessor :box
  attr_accessor :information

  attr_reader :box_class
  attr_reader :money_class

  def defaults
    { box_class: Box, money_class: Money }
  end

  def get_box(args)
    box = box_class.new(args[:box]) if args[:box]
    box = box_class.find(args[:box_id]) if args[:box_id]
    box
  end
end
