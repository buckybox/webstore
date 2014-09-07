require 'draper'
require "crazy_money"
require_relative '../models/product'

class ProductDecorator < Draper::Decorator
  delegate_all

  def price
    CrazyMoney.new(object.price).with_currency(context[:webstore].currency)
  end

  def order_link
    h.start_checkout_path(context[:webstore].id, id)
  end
end
