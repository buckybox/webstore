require_relative 'form'
require_relative '../webstore'

class Webstore::PaymentOptions < Webstore::Form
  attribute :cart
  attribute :name,              String
  attribute :phone_number,      String
  attribute :phone_type,        String
  attribute :street_address,    String
  attribute :street_address_2,  String
  attribute :suburb,            String
  attribute :city,              String
  attribute :postcode,          String
  attribute :delivery_note,     String
  attribute :payment_method,    String
  attribute :complete,          Boolean

  validates_presence_of :name
  validates_presence_of :require_phone,      if: :require_phone?
  validates_presence_of :require_address_1,  if: :require_address_1?
  validates_presence_of :require_address_2,  if: :require_address_2?
  validates_presence_of :require_suburb,     if: :require_suburb?
  validates_presence_of :require_city,       if: :require_city?
  validates_presence_of :require_postcode,   if: :require_postcode?
  validates_presence_of :payment_method

  def only_one_payment_option?
    distributor.only_one_payment_option?
  end

  def name
    #existing_customer? && current_customer.name
    'Holdername'
  end

  def phone_number
    #address.phones.default_number
    '123'
  end

  def phone_type
    #address.phones.default_type
    'mobile'
  end

  def street_address
    #address.address_1
    '123'
  end

  def street_address_2
    #address.address_2
    '123'
  end

  def suburb
    #address.suburb
    'burb'
  end

  def city
    #@distributor.invoice_information.billing_city if @distributor.invoice_information
    #address.city
    'city'
  end

  def postcode
    #address.postcode
    'e3e'
  end

  def delivery_note
    #address.delivery_note
    'this that'
  end

  def payment_method
    #'value'
    'paid'
  end

  def address
    #current_customer && current_customer.address
    ['12 Customer St']
  end

  def amount_due
    #closing_balance.negative
    Money.new(0)
  end

  def existing_customer?
    #current_customer && current_customer.persisted?
    true
  end

  def positive_closing_balance?
    #customer_signed_in? && @closing_balance.positive?
    false
  end

  def collect_phone?
    #@distributor.collect_phone?
    true
  end

  def has_address?
    #existing_customer?
    false
  end

  def payment_required
    #closing_balance.negative?
    true
  end

  def phone_types
    PhoneCollection::TYPES.each_key.map do |type|
      [ type.capitalize, type ]
    end
  end

  def payment_list
    PaymentOption.options(distributor)
  end

  def payment_instructions
    Webstore::PaymentInstructions.new(cart)
  end

  def to_h
    {
      name:              name,
      phone_number:      phone_number,
      phone_type:        phone_type,
      street_address:    street_address,
      street_address_2:  street_address_2,
      suburb:            suburb,
      city:              city,
      postcode:          postcode,
      delivery_note:     delivery_note,
      payment_method:    payment_method,
      complete:          complete,
    }
  end

private

  def distributor
    cart.distributor
  end

  def require_phone?
    distributor.require_phone
  end

  def require_address_1?
    distributor.require_address_1
  end

  def require_address_2?
    distributor.require_address_2
  end

  def require_suburb?
    distributor.require_suburb
  end

  def require_city?
    distributor.require_city
  end

  def require_postcode?
    distributor.require_postcode
  end
end
