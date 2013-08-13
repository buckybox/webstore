require_relative '../webstore'
require_relative '../customer'

class Webstore::CustomerFactory
  def self.assemble(args)
    customer_factory = new(args)
    customer_factory.assemble
  end

  def initialize(args)
    @cart = args[:cart]
    raise "cart is nil" if @cart.nil?

    derive_data
    # CustomerLogin.track(@webstore_order.customer) unless current_admin.present?
  end

  def assemble
    prepare_address
    prepare_customer
    customer.save!
    customer
  end

private

  attr_reader :cart
  attr_reader :customer
  attr_reader :order
  attr_reader :information
  attr_reader :address

  def prepare_address
    address.phone         = { number: phone_number, type: phone_type } if phone_number && phone_type
    address.address_1     = address_1     if address_1
    address.address_2     = address_2     if address_2
    address.suburb        = suburb        if suburb
    address.city          = city          if city
    address.postcode      = postcode      if postcode
    address.delivery_note = delivery_note if delivery_note
    address
  end

  def prepare_customer
    customer.email          = email          if email
    customer.distributor_id = distributor_id if distributor_id
    customer.route_id       = route_id       if route_id
    customer.name           = name           if name
    customer.address        = address
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

  def distributor_id
    cart.distributor.id
  end

  def route_id
    information[:route_id]
  end

  def name
    information[:name]
  end

  def derive_data
    @customer    = get_customer || ::Customer.new
    @address     = get_address  || customer.build_address
    @order       = get_order
    @information = get_order_information
  end

  def get_customer
    get_webstore_customer.existing_customer
  end

  def get_webstore_customer
    cart.customer
  end

  def get_address
    customer.address
  end

  def get_order
    cart.order
  end

  def get_order_information
    order.information
  end
end

