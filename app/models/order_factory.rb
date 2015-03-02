class OrderFactory
  def self.assemble(args)
    order_factory = new(args)
    order_factory.assemble
  end

  def initialize(args)
    @cart     = args.fetch(:cart)
    @customer = args[:customer]
    @order    = RecursiveOpenStruct.new
    derive_data
  end

  def assemble
    prepare_order
    API.create_order(order.to_json)
    order
  end

private

  attr_reader :cart
  attr_reader :customer
  attr_reader :order
  attr_reader :webstore_order

  def prepare_order
    order.customer_id    = customer_id
    order.box_id         = product_id
    order.order_extras   = order_extras
    order.extras_one_off = extras_one_off
    order.exclusions     = exclusions
    order.substitutions  = substitutions
    order.payment_method = payment_method
    schedule_rule.to_h.each { |k, v| order.public_send("#{k}=", v) }
    order.completed = true
    order
  end

  def product_id
    webstore_order.product_id
  end

  def customer_id
    customer.id
  end

  def schedule_rule
    webstore_order.schedule
  end

  def order_extras
    extra_id_and_counts.each_with_object({}) do |(id, count), hash|
      hash[id] = { count: count }
    end
  end

  def extras_one_off
    webstore_order.extra_frequency
  end

  def extra_id_and_counts
    webstore_order.extras || []
  end

  def exclusions
    webstore_order.exclusions
  end

  def substitutions
    webstore_order.substitutions
  end

  def payment_method
    webstore_order.payment_method
  end

  def derive_data
    @webstore_order = get_webstore_order
  end

  def get_webstore_order
    cart.order
  end
end
