#NOTE: Can be cleaned up with SimpleDelegator or Forwardable in std Ruby lib.

require 'draper'
require_relative '../webstore'

class Webstore::Customer
  include Draper::Decoratable

  attr_reader :cart
  attr_reader :existing_customer_id

  GUEST_HALTED     = false
  GUEST_DISCOUNTED = false
  GUEST_ACTIVE     = false

  def initialize(args = {})
    @cart                 = args.fetch(:cart, nil)
    @existing_customer_id = args.fetch(:existing_customer_id, nil)
    @customer_class       = args.fetch(:customer_class, ::Customer)
  end

  def fetch(key, default_value = nil)
    send(key) || default_value
  end

  def guest?
    !existing_customer
  end

  def existing_customer
    customer_class.find(existing_customer_id) if existing_customer_id
  end

  def distributor
    existing_customer.distributor if existing_customer
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

  def delivery_service_id
    existing_customer.delivery_service.id if existing_customer.present? && existing_customer.delivery_service.present?
  end

  def address
    existing_customer ? existing_customer.address : NullObject.new
  end

  def account_balance
    existing_customer ? existing_customer.account_balance : EasyMoney.new(0)
  end

  def balance_threshold
    existing_customer.balance_threshold
  end

private

  attr_reader :customer_class
end
