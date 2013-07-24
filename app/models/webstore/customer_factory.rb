require_relative '../webstore'
require_relative '../customer'

class Webstore::CustomerFactory
  def self.assemble(args)
    customer_factory = new(args)
    customer_factory.assemble
  end

  def initialize(args)
    @cart = args[:cart]
    derive_data
    # CustomerLogin.track(@webstore_order.customer) unless current_admin.present?
  end

  def assemble
    prepare_address
    prepare_customer
    customer.save
    customer
  end

private

  attr_reader :cart
  attr_reader :customer
  attr_reader :order
  attr_reader :information
  attr_reader :address

  def prepare_address
    address.phone         = { number: phone_number, type:   phone_type }
    address.address_1     = street_address
    address.address_2     = street_address_2
    address.suburb        = suburb
    address.city          = city
    address.postcode      = postcode
    address.delivery_note = delivery_note
    address
  end

  def prepare_customer
    if customer.valid?
      customer.email          = email
      customer.distributor_id = distributor_id
      customer.route_id       = route_id
      customer.first_name     = first_name
      customer.address        = address
    end

    customer.first_name = first_name
    customer.via_webstore!
    customer
  end

  def phone_number
    information[:phone_number]
  end

  def phone_type
    information[:phone_type]
  end

  def address_1
    information[:street_address]
  end

  def address_2
    information[:street_address_2]
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

  def distributor_id
    cart.distributor.id
  end

  def route_id
    information[:route_id]
  end

  def first_name
    information[:name]
  end

  def derive_data
    self.customer    = get_customer || Customer.new
    self.address     = get_address || customer.build_address
    self.order       = get_order
    self.information = get_order_information
  end

  def get_customer
    cart.customer.existing_customer
  end

  def address
    customer.address
  end

  def get_order
    cart.order
  end

  def get_order_information
    order.information
  end
end

