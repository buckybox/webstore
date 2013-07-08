require 'draper'
require_relative '../../models/webstore/order'
require_relative '../extra_decorator'

class Webstore::OrderDecorator < Draper::Decorator
  delegate_all

  def box_price
    object.box_price.format
  end

  def extras_price
    object.extras_price.format
  end

  def delivery_fee
    object.delivery_fee.format
  end

  def bucky_fee
    object.bucky_fee.format
  end

  def discount
    object.discount.format
  end

  def total
    object.total.format
  end

  def extras(extra_decorator = ExtraDecorator)
    e = object.extras
    extra_decorator.decorate_collection(e)
  end

  def exclusions
    object.exclusion_line_items.map(&:name).join(', ')
  end

  def substitutions
    object.substitution_line_items.map(&:name).join(', ')
  end
end
