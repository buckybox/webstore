class OrderPrice
  def self.discounted(price, customer_discount = nil)
    return price if customer_discount.nil? # Convenience so we don't have to check all over app for nil

    customer_discount = BigDecimal.new(customer_discount.discount.to_s) if customer_discount.respond_to?(:discount)

    price * (1 - customer_discount)
  end

  def self.extras_price(order_extras, customer_discount = nil)
    customer_discount = BigDecimal.new(customer_discount.discount.to_s) if customer_discount.respond_to?(:discount)

    total_price = order_extras.map do |order_extra|
      CrazyMoney.new(order_extra[:price]) * order_extra[:count]
    end.sum

    discounted(total_price, customer_discount)
  end
end
