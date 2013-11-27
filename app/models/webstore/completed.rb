require_relative 'form'
require_relative '../webstore'

class Webstore::Completed < Webstore::Form
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
      bank_information.customer_message
    when "cash_on_delivery"
      bank_information.cod_payment_message
    end
  end

  def bank_name
    bank_information.bank_name
  end

  def bank_account_name
    bank_information.bank_account_name
  end

  def bank_account_number
    bank_information.bank_account_number
  end

  def customer_number
    real_customer.formated_number
  end

  def note
    bank_information.customer_message
  end

  def distributor
    real_customer.distributor
  end

  def bank_information
    distributor.bank_information.decorate
  end
end
