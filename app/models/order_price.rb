# frozen_string_literal: true

class OrderPrice
  def self.discounted(price, customer)
    return price if customer.nil?

    customer_discount = BigDecimal.new(customer.discount.to_s)
    price * (1 - customer_discount)
  end

  def self.extras_price(order_extras, customer)
    total_price = order_extras.sum do |order_extra|
      CrazyMoney.new(order_extra.fetch(:price)) * order_extra.fetch(:count)
    end

    discounted(total_price, customer)
  end
end
