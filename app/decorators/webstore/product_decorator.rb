require 'draper'
require_relative '../../models/webstore/product'

module Webstore
  class ProductDecorator < Draper::Decorator
    delegate_all

    def price
      object.price.format
    end

    def order_link
      h.webstore_checkout_path(distributor_parameter_name, box)
    end

  private

    def distributor_parameter_name
      object.distributor.parameter_name
    end
  end
end
