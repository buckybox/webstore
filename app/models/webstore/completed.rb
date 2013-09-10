require_relative 'form'
require_relative '../webstore'

class Webstore::Completed < Webstore::Form
  attribute :cart
  attribute :real_order
  attribute :real_customer

  def customer_name
    real_customer.name
  end

  def customer_address
    real_customer.address.join('<br>')
  end

  def schedule_description
    real_order.schedule_rule
  end

  def payment_method
    cart.payment_method
  end

  def payment_title
    payment_method.titleize
  end

  def payment_message
    case payment_method
    when "bank_deposit"
      distributor.bank_information.customer_message
    when "cash_on_delivery"
      distributor.bank_information.cod_payment_message
    end
  end

  def bank_name
    distributor.bank_information.name
  end

  def bank_account_name
    distributor.bank_information.account_name
  end

  def bank_account_number
    distributor.bank_information.account_number
  end

  def customer_number
    real_customer.number
  end

  def distributor
    real_customer.distributor
  end
end
