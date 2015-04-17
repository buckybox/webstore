require 'draper'
require_relative 'order_price'

class Order
  include Draper::Decoratable

  attr_reader :cart
  attr_reader :product_id
  attr_reader :information

  delegate :name, to: :product, prefix: true
  delegate :description, to: :product, prefix: true
  delegate :name, to: :delivery_service, prefix: true

  def initialize(args = {})
    @cart                   = args.fetch(:cart)
    @information            = args.fetch(:information, {})
    @product_id             = args.fetch(:product_id, nil)
  end

  def add_product(product_id)
    @product_id = product_id
  end

  def add_information(new_information)
    information.merge!(new_information.to_h)
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

  def has_total?
    !information.empty?
  end

  def has_discount?
    customer.discount?
  end

  def for_halted_customer?
    customer.halted?
  end

  def exclusion_line_items
    cart.stock_list.select { |line_item| line_item.id.in?(exclusions) }
  end

  def substitution_line_items
    cart.stock_list.select { |line_item| line_item.id.in?(substitutions) }
  end

  def extras_as_objects
    extra_ids = extras ? extras.keys : []
    product.extras.select { |extra| extra_ids.include?(extra.id) }
  end

  def total(with_discount: true)
    product_price(with_discount: with_discount) +
      extras_price(with_discount: with_discount) +
      delivery_service_fee
  end

  def discount
    total(with_discount: false) - total(with_discount: true)
  end

  def product_price(order_price_class = ::OrderPrice, with_discount: true)
    customer = with_discount ? existing_customer : nil
    order_price_class.discounted(product.price, customer)
  end

  def extras_price(order_price_class = ::OrderPrice, with_discount: true)
    customer = with_discount ? existing_customer : nil
    order_price_class.extras_price(extras_as_hashes, customer)
  end

  def delivery_service_fee
    delivery_service ? delivery_service.fee : 0
  end

  def product
    API.box(product_id)
  end

  def extras_list
    product.extras
  end

  def product_image
    product.images.webstore
  end

  def extra_quantity(extra)
    extras[extra.id]
  end

  def schedule(schedule_builder_class = ScheduleRule)
    schedule_builder_class.new(
      start_date:  start_date,
      frequency:   frequency,
      days:        days,
    )
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
    product.customizable
  end

  def invalid?
    product # fetch the actual product and make sure it exists
    false
  rescue BuckyBox::API::NotFoundError
    true
  end

  def delivery_service
    API.delivery_service(delivery_service_id) if delivery_service_id
  end

  def pickup_point?
    delivery_service.pickup_point
  end

  def recurring?
    frequency != "single"
  end

  def customer
    cart ? cart.customer : Customer.new
  end

  def frequency
    information[:frequency]
  end

private

  attr_writer :product
  attr_writer :information

  def existing_customer
    cart ? cart.existing_customer : nil
  end

  def extras_as_hashes
    extras_as_objects.each_with_object([]) do |extra, array|
      count = extra_quantity(extra)
      array << extra.to_hash.with_indifferent_access.merge(count: count)
    end
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
