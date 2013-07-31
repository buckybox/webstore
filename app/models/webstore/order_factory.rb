require_relative '../webstore'
require_relative '../order'

class Webstore::OrderFactory
  def self.assemble(args)
    order_factory = new(args)
    order_factory.assemble
  end

  def initialize(args)
    @cart     = args[:cart]
    @customer = args[:customer]
    @order    = ::Order.new
    derive_data
  end

  def assemble
    prepare_order
    order.save!
    order
  end

private

  attr_reader :cart
  attr_reader :customer
  attr_reader :order
  attr_reader :webstore_order

  def prepare_order
    order.box                       = box
    order.account                   = account
    order.schedule_rule_attributes  = schedule_rule
    order.order_extras              = order_extras
    order.extras_one_off            = extras_one_off
    order.excluded_line_item_ids    = excluded_line_item_ids
    order.substituted_line_item_ids = substituted_line_item_ids
    order.completed!
    order
  end

  def box
    webstore_order.box
  end

  def account
    customer.account
  end

  def schedule_rule
    webstore_order.schedule.clone_attributes
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
    webstore_order.extras
  end

  def excluded_line_item_ids
    webstore_order.exclusions
  end

  def substituted_line_item_ids
    webstore_order.substitutions
  end

  def derive_data
    @webstore_order = get_webstore_order
  end

  def get_webstore_order
    cart.order
  end
end
