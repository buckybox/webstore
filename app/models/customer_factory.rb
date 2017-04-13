# frozen_string_literal: true

class CustomerFactory
  CustomerWrapper = Struct.new(
    :id, :address, :via_webstore, :email, :delivery_service_id,
    :first_name, :last_name
  )

  AddressWrapper = Struct.new(
    :address_1, :address_2, :suburb, :city, :postcode, :delivery_note,
    :home_phone, :mobile_phone, :work_phone
  )

  def self.assemble(args)
    customer_factory = new(args)
    customer_factory.assemble
  end

  def initialize(args)
    @cart = args.fetch(:cart)
    derive_data
  end

  def assemble
    prepare_address
    prepare_customer
    API.create_or_update_customer(customer.to_json)
  end

private

  attr_reader :cart
  attr_reader :customer
  attr_reader :order
  attr_reader :information
  attr_reader :address

  def assign_attributes_to_object(object, attributes)
    attributes.each do |attribute|
      value = send(attribute)
      object.public_send("#{attribute}=", value) if value
    end

    object
  end

  def prepare_address
    address.public_send("#{phone_type}_phone=", phone_number) if phone_number && phone_type.present?
    assign_attributes_to_object(address, %i[address_1 address_2 suburb city postcode delivery_note])
  end

  def prepare_customer
    customer.id           = existing_customer_id if existing_customer_id
    customer.address      = address
    customer.via_webstore = true
    assign_attributes_to_object(customer, %i[email delivery_service_id first_name last_name])
  end

  def phone_number
    information[:phone_number]
  end

  def phone_type
    information[:phone_type]
  end

  def address_1
    information[:address_1]
  end

  def address_2
    information[:address_2]
  end

  def suburb
    information[:suburb]
  end

  def city
    information[:city]
  end

  def postcode
    information[:postcode]
  end

  def delivery_note
    information[:delivery_note]
  end

  def email
    information[:email]
  end

  def delivery_service_id
    information[:delivery_service_id]
  end

  def name
    information[:name].split(" ", 2)
  end

  def first_name
    name.first
  end

  def last_name
    name.last
  end

  def derive_data
    @customer    = CustomerWrapper.new
    @address     = AddressWrapper.new
    @order       = cart.order
    @information = order.information
  end

  def existing_customer_id
    cart.customer.existing_customer_id
  end
end
