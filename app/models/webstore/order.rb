#NOTE: Can be cleaned up with SimpleDelegator or Forwardable in std Ruby lib.

require 'draper'
require_relative '../webstore'
require_relative '../order_price'

class Webstore::Order
  include Draper::Decoratable

  attr_reader :cart
  attr_reader :product_id
  attr_reader :information

  def initialize(args = {})
    @cart          = args.fetch(:cart)
    @information   = args.fetch(:information, {})
    @product_id    = args.fetch(:product_id, nil)
    @delivery_service_class   = args.fetch(:delivery_service_class, ::DeliveryService)
    @product_class = args.fetch(:product_class, ::Box)
  end

  def add_product(product_id)
    @product_id = product_id
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
    result = pre_discount_total
    result += discount if has_discount?
    result
  end

  def pre_discount_total
    result = product_price
    result += extras_price if has_extras?
    result += delivery_fee if is_scheduled?
    result += bucky_fee    if has_bucky_fee?
    result
  end

  def product_price(order_price_class = ::OrderPrice)
     order_price_class.discounted(product.price, existing_customer)
  end

  def extras_price(order_price_class = ::OrderPrice)
    order_price_class.extras_price(extras_as_hashes, existing_customer)
  end

  def delivery_fee(order_price_class = ::OrderPrice)
    order_price_class.discounted(delivery_service_fee, existing_customer)
  end

  def bucky_fee
    distributor.consumer_delivery_fee
  end

  def discount(order_price_class = ::OrderPrice)
    order_price_class.discounted(pre_discount_total, existing_customer) - pre_discount_total
  end

  def product
    product_class.find(product_id)
  end

  def extras_list
    product.available_extras
  end

  def product_image
    product.webstore_image_url
  end

  def product_name
    product.name
  end

  def product_description
    product.description
  end

  def extra_quantity(extra)
    extras[extra.id]
  end

  def schedule(schedule_builder_class = ::ScheduleBuilder)
    schedule_builder_class.build({
      start_date:  start_date,
      frequency:   frequency,
      days:        days,
    })
  end

  def exclusions
    information[:dislikes]
  end

  def substitutions
    information[:likes]
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
    product.customisable?
  end

private

  attr_reader :delivery_service_class
  attr_reader :product_class

  attr_writer :product
  attr_writer :information

  def distributor
    cart.distributor ? cart.distributor : ::Distributor.new
  end

  def delivery_service
    delivery_service_class.where(id: delivery_service_id).first
  end

  def customer
    cart ? cart.customer : Webstore::Customer.new
  end

  def delivery_service_fee
    delivery_service.fee if delivery_service
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

  def delivery_service_id
    information[:delivery_service_id]
  end
end
