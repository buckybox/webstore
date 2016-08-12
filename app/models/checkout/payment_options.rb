# frozen_string_literal: true

require_relative "../form"

class PaymentOptions < Form
  PAID = "paid"

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

  validates :name,           presence: true
  validates :phone_number,   presence: true, if: :require_phone
  validates :phone_type,     presence: true, if: :require_phone
  validates :address_1,      presence: true, if: :require_address_1
  validates :address_2,      presence: true, if: :require_address_2
  validates :suburb,         presence: true, if: :require_suburb
  validates :city,           presence: true, if: :require_city
  validates :postcode,       presence: true, if: :require_postcode
  validates :delivery_note,  presence: true, if: :require_delivery_note
  validates :payment_method, presence: true, if: :has_payment_options?

  attr_reader :address

  delegate :collect_phone, :require_phone, :collect_delivery_note, to: :webstore
  delegate :has_payment_options?, to: :cart
  delegate :address, to: :customer, prefix: true
  delegate :delivery_service, to: :order

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

  def phone_types(phone_collection_class = ::PhoneCollection)
    phone_collection_class.types_as_options
  end

  def pickup_point?
    delivery_service.pickup_point
  end

  def require_address_1
    !pickup_point? && webstore.require_address_1
  end

  def require_address_2
    !pickup_point? && webstore.require_address_2
  end

  def require_suburb
    !pickup_point? && webstore.require_suburb
  end

  def require_city
    !pickup_point? && webstore.require_city
  end

  def require_postcode
    !pickup_point? && webstore.require_postcode
  end

  def require_delivery_note
    !pickup_point? && webstore.require_delivery_note
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

  def after_standard_initialize(_attributes)
    @address = build_address
  end

private

  attr_reader :address_class

  def defaults
    { address_class: ::Address }
  end

  def build_address
    address = if customer.existing_customer
      address_class.new(customer.existing_customer.address.to_h)
    else
      address_class.new
    end

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

  def webstore
    cart.webstore
  end

  def customer
    cart.customer
  end

  def order
    cart.order
  end
end
