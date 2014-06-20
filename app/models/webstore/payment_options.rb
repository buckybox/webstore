require_relative 'form'
require_relative '../webstore'

class Webstore::PaymentOptions < Webstore::Form
  extend Forwardable

  include Customer::AddressValidations

  attribute :name,            String
  attribute :phone_number,    String
  attribute :phone_type,      String
  attribute :payment_method,  String
  attribute :complete,        Boolean

  validates_presence_of :name,          if: :require_name
  validates_presence_of :phone_number,  if: :require_phone
  validates_presence_of :phone_type,    if: :require_phone

  attr_reader :address

  def_delegators :distributor,
    :collect_phone,
    :collect_delivery_note

  def name
    super || customer.name
  end

  def default_phone_number
    phone_number || address.default_phone_number
  end

  def default_phone_type
    phone_type || address.default_phone_type
  end

  def existing_customer?
    !customer.guest?
  end

  def only_one_payment_option?
    distributor.only_one_payment_option?
  end

  def phone_types(phone_collection_class = ::PhoneCollection)
    phone_collection_class.types_as_options
  end

  def payment_list(payment_options_class = ::PaymentOption)
    payment_options_class.options(distributor)
  end

  def customer_address
    customer.address
  end

  def require_name
    !pickup_point?
  end

  def require_phone
    !pickup_point? && distributor.require_phone
  end

  # Returns whether the address is valid or not so we can hide the edit form when it is valid
  def address_complete?
    previous_errors = errors.dup

    begin
      valid? # populate `errors`
      (errors.keys - [:phone_type, :payment_method]).empty?
    ensure
      # make sure we reset `errors` to its previous value for SimpleForm
      # kinda hackish but does the trick until we split up the models
      @errors = previous_errors
    end
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
      address_value = address.public_send(attribute)
      public_send("#{attribute}=", address_value) unless public_send(attribute)
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

  def order
    cart.order
  end

  def delivery_service
    order.delivery_service
  end
end
