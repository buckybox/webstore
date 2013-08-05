#NOTE: Can be cleaned up with SimpleDelegator or Forwardable in std Ruby lib.

require 'draper'
require_relative '../webstore'

class Webstore::Customer
  include Draper::Decoratable

  attr_reader :distributor
  attr_reader :existing_customer
  attr_reader :cart

  GUEST_HALTED     = false
  GUEST_DISCOUNTED = false
  GUEST_ACTIVE     = false

  def initialize(args = {})
    @cart              = args.fetch(:cart, nil)
    @existing_customer = args.fetch(:existing_customer, nil)
    @distributor       = existing_customer ? existing_customer.distributor : args.fetch(:distributor, nil)
  end

  def fetch(key, default_value = nil)
    send(key) || default_value
  end

  def guest?
    !existing_customer
  end

  def associate_real_customer(customer)
    @existing_customer = customer
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

  def route_id
    existing_customer.route.id if active?
  end

  def address
    existing_customer ? existing_customer.address : NullObject.new
  end

  def account_balance
    existing_customer ? existing_customer.account_balance : Money.new(0)
  end

  def balance_threshold
    existing_customer.balance_threshold
  end
end
