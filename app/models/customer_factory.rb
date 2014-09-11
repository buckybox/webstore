class CustomerFactory
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
    customer
  end

private

  attr_reader :cart
  attr_reader :customer
  attr_reader :order
  attr_reader :information
  attr_reader :address

  def prepare_address
    address.send("#{phone_type}_phone=", phone_number) if phone_number && !phone_type.blank?
    address.address_1     = address_1     if address_1
    address.address_2     = address_2     if address_2
    address.suburb        = suburb        if suburb
    address.city          = city          if city
    address.postcode      = postcode      if postcode
    address.delivery_note = delivery_note if delivery_note
    address
  end

  def prepare_customer
    customer.id                  = existing_customer_id if existing_customer_id
    customer.email               = email               if email
    customer.delivery_service_id = delivery_service_id if delivery_service_id
    customer.first_name          = first_name          if first_name
    customer.last_name           = last_name           if last_name
    customer.address             = address
    customer.via_webstore        = true
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
    @customer    = RecursiveOpenStruct.new
    @address     = RecursiveOpenStruct.new
    @order       = cart.order
    @information = order.information
  end

  def existing_customer_id
    cart.customer.existing_customer_id
  end

  # def get_customer
  #   get_webstore_customer.existing_customer
  # end

  # def get_webstore_customer
  #   cart.customer
  # end

  # def get_address
  #   address = customer.address
  #   # address = Address.new(address.to_h) unless address.is_a?(Address)
  #   address
  # end

#   def get_order
#     cart.order
#   end

#   def get_order_information
#     order.information
#   end
end

