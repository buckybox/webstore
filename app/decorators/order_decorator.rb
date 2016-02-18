# frozen_string_literal: true

require 'draper'
require_relative '../models/order'

class OrderDecorator < Draper::Decorator
  delegate_all

  def product_price
    product_price = object.product_price(with_discount: false)
    product_price.zero? ? "" : product_price.with_currency(context[:currency])
  end

  def extras_price
    object.extras_price(with_discount: false).with_currency(context[:currency])
  end

  def delivery_service_fee
    object.delivery_service_fee.with_currency(context[:currency])
  end

  def discount
    object.discount.opposite.with_currency(context[:currency])
  end

  def total
    total = object.total
    total.zero? ? "" : total.with_currency(context[:currency])
  end

  def extras
    object.extras_as_objects
  end

  def exclusions
    object.exclusion_line_items.map(&:name).join(', ')
  end

  def substitutions
    object.substitution_line_items.map(&:name).join(', ')
  end
end
