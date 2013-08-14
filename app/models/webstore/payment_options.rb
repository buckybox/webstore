require_relative 'form'
require_relative '../webstore'

class Webstore::PaymentOptions < Webstore::Form
  attribute :cart
  attribute :name,            String
  attribute :phone_number,    String
  attribute :phone_type,      String
  attribute :address_1,       String
  attribute :address_2,       String
  attribute :suburb,          String
  attribute :city,            String
  attribute :postcode,        String
  attribute :delivery_note,   String
  attribute :payment_method,  String
  attribute :complete,        Boolean

  validates_presence_of :name
  validates_presence_of :phone_number,  if: :require_phone
  validates_presence_of :phone_type,    if: :require_phone
  validates_presence_of :address_1,     if: :require_address_1
  validates_presence_of :address_2,     if: :require_address_2
  validates_presence_of :suburb,        if: :require_suburb
  validates_presence_of :city,          if: :require_city
  validates_presence_of :postcode,      if: :require_postcode
  validates_presence_of :payment_method

  attr_reader :address

  def name
    super || customer.name
  end

  def default_phone_number
    phone_number || address.default_phone_number
  end

  def default_phone_type
    phone_type || address.default_phone_type
  end

  def city
    super || distributor.city
  end

  def existing_customer?
    !customer.guest?
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

  def require_phone
    distributor.require_phone
  end

  def require_address_1
    distributor.require_address_1
  end

  def require_address_2
    distributor.require_address_2
  end

  def require_suburb
    distributor.require_suburb
  end

  def require_city
    distributor.require_city
  end

  def require_postcode
    distributor.require_postcode
  end

  def customer_address
    customer.address
  end

  def to_h
    {
      name:            name,
      phone_number:    phone_number,
      phone_type:      phone_type,
      address_1:       address_1,
      address_2:       address_2,
      suburb:          suburb,
      city:            city,
      postcode:        postcode,
      delivery_note:   delivery_note,
      payment_method:  payment_method,
      complete:        complete,
    }
  end

protected

  def before_standard_initialize(attributes)
    attributes = defaults.merge(attributes)
    @address_class = attributes.delete(:address_class)
  end

  def after_standard_initialize(attributes)
    @address = build_address
  end

private

  attr_reader :address_class

  def defaults
    { address_class: ::Address }
  end

  def build_address
    address = customer.existing_customer.address if customer.existing_customer
    address ||= address_class.new

    # forward address attributes
    address_class.address_attributes.each do |attribute|
      address.public_send("#{attribute}=", public_send(attribute))
    end

    # set phone number
    address.phone = { type: phone_type, number: phone_number }

    address
  end

  def cart
    super || BlackHole.new
  end

  def distributor
    cart.distributor
  end

  def customer
    cart.customer
  end

end
