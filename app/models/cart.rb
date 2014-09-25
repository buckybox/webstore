#NOTE: Can be cleaned up with SimpleDelegator or Forwardable in std Ruby lib.

require "draper"
require_relative "order"
require_relative "customer"

class Cart
  include Draper::Decoratable

  attr_reader :id
  attr_reader :order
  attr_reader :customer
  attr_reader :webstore_id
  attr_reader :real_order_id # from factory
  attr_reader :real_customer_id # from factory

  def self.find(id, persistence_class = CartPersistence)
    persistence = persistence_class.find(id)
    persistence.cart if persistence
  end

  def initialize(args = {})
    @id                = args[:id]
    @order             = new_order(args)
    @customer          = new_customer(args)
    @webstore_id       = args.fetch(:webstore_id)
    @persistence_class = args.fetch(:persistence_class, CartPersistence)
  end

  def new?
    id.nil?
  end

  def completed?
    @completed
  end

  def ==(comparison_cart)
    if new?
      self.object_id == comparison_cart.object_id
    else
      self.id == comparison_cart.id
    end
  end

  def save
    persistence = find_or_create_persistence
    persistence.save(self) and self.id = persistence.id
  end

  delegate :add_product, to: :order

  delegate :existing_customer, to: :customer

  def webstore
    API.webstore(webstore_id)
  end

  def stock_list
    webstore.line_items
  end

  delegate :extras_list, to: :order

  def add_order_information(information)
    order.add_information(information)
  end

  delegate :product, to: :order

  delegate :delivery_service, to: :customer

  delegate :has_extras?, to: :order

  delegate :payment_method, to: :order

  def payment_list
    webstore.payment_options
  end

  def has_payment_options?
    payment_list.present?
  end

  def negative_closing_balance?
    closing_balance.negative?
  end

  def closing_balance
    current_balance - order_price
  end

  def current_balance
    customer.account_balance
  end

  def order_price
    order.total
  end

  def amount_due
    [order_price - current_balance, CrazyMoney.zero].max
  end

  def run_factory(factory_class = Factory)
    factory = factory_class.assemble(cart: self)

    @real_order_id = factory.order.id
    @real_customer_id = factory.customer.id
    customer.associate_real_customer(@real_customer_id)
    completed!

    factory.customer.add_activity(:order_create, order: factory.order)
    send_confirmation_email(factory.order) if webstore.email_customer_on_new_webstore_order

    factory
  end

private

  attr_reader :persistence_class
  attr_writer :id

  def new_order(args)
    args = args.fetch(:order, {})
    args = args.merge(cart: self)
    Order.new(args)
  end

  def new_customer(args)
    args = args.fetch(:customer, {})
    args = args.merge(cart: self)
    Customer.new(args)
  end

  def find_or_create_persistence
    persistence = persistence_class.find(id)
    persistence = persistence_class.new unless persistence
    persistence
  end

  def completed!
    @completed = true
    save
  end

  def send_confirmation_email(order)
    CustomerMailer.delay(
      priority: Figaro.env.delayed_job_priority_high,
      queue: "#{__FILE__}:#{__LINE__}",
    ).order_confirmation(order)
  end
end
