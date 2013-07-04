require_relative 'form'
require_relative '../webstore'

class Webstore::Completed < Webstore::Form
  attribute :cart

  def distributor_parameter_name
    cart.distributor_parameter_name
  end

  def existing_customer?
    #current_customer && current_customer.persisted?
    true
  end

  def payment_method
    #'value'
    :bank_deposit
  end

  def payment_instructions
    Webstore::PaymentInstructions.new(cart)
  end

  def payment_message
    #If cod
    #@distributor.bank_information.cod_payment_message
    #if bank dep
    #distributor.bank_information.customer_message
    'This is Bank Info'
  end

  def bank_name
    #distributor.bank_information.name
    'a bank'
  end

  def bank_account_name
    #distributor.bank_information.account_name
    'an account'
  end

  def bank_bsb_number
    #distributor.bank_information.bsb_number
    '123'
  end

  def bank_account_number
    #distributor.bank_information.account_number
    '123'
  end

  def customer_number
    #distributor.bank_information.customer_number
    '0013'
  end

  def customer_name
    #@customer.name
    'customer name'
  end

  def customer_address
    #@address.join('<br>')
    '123 Street Ad'
  end

  def next_delivery_occurrence
    #@schedule_rule.next_occurrence.to_s(:day_month_date_year)
    '2013-12-12'
  end

  def schedule_description
    #@schedule_rule
    'Delivery monthly on the first Thursday'
  end
end
