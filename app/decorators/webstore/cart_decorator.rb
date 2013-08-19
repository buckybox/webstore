require "draper"
require_relative "../../models/webstore/cart"

class Webstore::CartDecorator < Draper::Decorator
  delegate_all

  def current_balance
    object.current_balance.format
  end

  def closing_balance
    object.closing_balance.format
  end

  def order_price
    object.order_price.format
  end

  def amount_due
    object.amount_due.format
  end
end
