# frozen_string_literal: true

require "draper"

class Customer
  include Draper::Decoratable

  attr_reader :cart
  attr_reader :existing_customer_id

  GUEST_HALTED     = false
  GUEST_DISCOUNTED = false
  GUEST_ACTIVE     = false

  delegate :balance_threshold, to: :existing_customer

  def self.exists?(args)
    API.customers(args).present?
  end

  def self.find(id)
    API.customer(id, embed: "address")
  end

  def initialize(args = {})
    @cart                 = args.fetch(:cart, nil)
    @existing_customer_id = args.fetch(:existing_customer_id, nil)
  end

  def fetch(key, default_value = nil)
    send(key) || default_value
  end

  def guest?
    !existing_customer
  end

  def existing_customer
    self.class.find(existing_customer_id) if existing_customer_id
  end

  def associate_real_customer(customer_id)
    @existing_customer_id = customer_id
  end

  def halted?
    guest? ? GUEST_HALTED : existing_customer.halted?
  end

  def discount?
    guest? ? GUEST_DISCOUNTED : existing_customer.discount?
  end

  def active?
    guest? ? GUEST_ACTIVE : existing_customer.active?
  end

  def name
    existing_customer.name unless guest?
  end

  def email
    existing_customer.email unless guest?
  end

  def delivery_service_id
    existing_customer.delivery_service_id if existing_customer.present? && existing_customer.delivery_service_id.present?
  end

  def address
    existing_customer ? Address.new(existing_customer.address.to_h) : NullObject.new
  end

  def account_balance
    existing_customer ? existing_customer.account_balance : CrazyMoney.zero
  end

  def number
    raise "No number for guest customer" if guest?

    existing_customer.number
  end
end
