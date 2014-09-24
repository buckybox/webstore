require 'draper'
require_relative '../../models/webstore/order'
# require_relative '../extra_decorator'

class OrderDecorator < Draper::Decorator
  delegate_all

  def product_price
    object.product_price(with_discount: false).with_currency(context[:currency])
  end

  def extras_price
    object.extras_price(with_discount: false).with_currency(context[:currency])
  end

  def delivery_service_fee
    object.delivery_service_fee.with_currency(context[:currency])
  end

  def bucky_fee
    object.bucky_fee.with_currency(context[:currency])
  end

  def discount
    object.discount.opposite.with_currency(context[:currency])
  end

  def total
    object.total.with_currency(context[:currency])
  end

  def extras(extra_decorator = ExtraDecorator)
    extra_decorator.decorate_collection(object.extras_as_objects)
  end

  def exclusions
    object.exclusion_line_items.map(&:name).join(', ')
  end

  def substitutions
    object.substitution_line_items.map(&:name).join(', ')
  end
end
