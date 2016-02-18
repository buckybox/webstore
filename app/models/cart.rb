# frozen_string_literal: true

require "draper"
require_relative "order"
require_relative "customer"

class Cart
  include Draper::Decoratable

  attr_reader :id
  attr_reader :order
  attr_reader :customer
  attr_reader :webstore_id

  delegate :delivery_service,  to: :customer
  delegate :existing_customer, to: :customer

  delegate :add_product,    to: :order
  delegate :extras_list,    to: :order
  delegate :product,        to: :order
  delegate :has_extras?,    to: :order
  delegate :payment_method, to: :order

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

  def ==(other)
    if new?
      object_id == other.object_id
    else
      id == other.id
    end
  end

  def save
    persistence = find_or_create_persistence
    persistence.save(self) and self.id = persistence.id
  end

  def webstore
    API.webstore(webstore_id)
  end

  def stock_list
    webstore.line_items
  end

  def add_order_information(information)
    order.add_information(information)
  end

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
    customer_id = factory.customer.id
    customer.associate_real_customer(customer_id)
    completed!
    factory
  end

private

  attr_reader :persistence_class
  attr_writer :id

  def new_model(model, args)
    args = args.fetch(model, {})
    args = args.merge(cart: self)

    model.to_s.humanize.constantize.new(args)
  end

  def new_order(args)
    new_model(:order, args)
  end

  def new_customer(args)
    new_model(:customer, args)
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
end
