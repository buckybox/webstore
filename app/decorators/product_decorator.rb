require 'draper'
require_relative '../models/product'

class ProductDecorator < Draper::Decorator
  delegate_all

  def price
    object.price.with_currency(object.distributor.currency)
  end

  def order_link
    h.webstore_start_checkout_path(distributor_parameter_name, box)
  end

private

  def distributor_parameter_name
    object.distributor.parameter_name
  end
end
