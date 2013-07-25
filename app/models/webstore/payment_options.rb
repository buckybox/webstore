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

  def address
    customer.address
  end

  def phone_number
    address.default_phone_number
  end

  def phone_type
    address.default_phone_type
  end

  def street_address
    address.address_1
  end

  def street_address_2
    address.address_2
  end

  def suburb
    address.suburb
  end

  def postcode
    address.postcode
  end

  def delivery_note
    address.delivery_note
  end

  def city
    existing_customer? ? address.city : distributor.city
  end

  def existing_customer?
    !customer.guest?
  end

  def name
    customer.name if existing_customer?
  end

  def only_one_payment_option?
    distributor.only_one_payment_option?
  end

  def collect_phone?
    distributor.collect_phone?
  end

  def phone_types(phone_collection_class = ::PhoneCollection)
    phone_collection_class.types_as_options
  end

  def payment_list(payment_options_class = ::PaymentOption)
    payment_options_class.options(distributor)
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

  def customer
    cart.customer
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
