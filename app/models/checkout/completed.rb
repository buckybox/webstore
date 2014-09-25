require_relative '../form'

class Completed < Form
  attribute :real_order
  attribute :real_customer

  def customer_name
    real_customer.name
  end

  def customer_email
    real_customer.email
  end

  delegate :paypal_email, to: :distributor, prefix: true

  def customer_address
    real_customer.address.join('<br>')
  end

  def customer_number
    real_customer.formated_number
  end

  def schedule_description
    real_order.schedule_rule
  end

  def product_name
    real_order.box.name
  end

  delegate :payment_method, to: :cart

  def payment_recurring?
    !schedule_rule.one_off?
  end

  delegate :amount_due, to: :cart

  def amount_due_without_symbol
    undecorated_cart = cart.decorated? ? cart.object : cart
    undecorated_cart.amount_due
  end

  def payment_title
    method = payment_method.underscore
    method = "paypal_cc" if method == "paypal" # XXX: terrible hack, can't be fucked with that now

    I18n.t(method)
  end

  def payment_message
    case payment_method
    when "bank_deposit"
      bank_information.customer_message
    when "cash_on_delivery"
      bank_information.cod_payment_message
    end
  end

  delegate :bank_name, to: :bank_information

  delegate :bank_account_name, to: :bank_information

  delegate :bank_account_number, to: :bank_information

  def customer_number
    real_customer.formated_number
  end

  def note
    bank_information.customer_message
  end

  delegate :distributor, to: :real_customer

  def bank_information
    distributor.bank_information.decorate
  end

  delegate :currency, to: :distributor

  def top_up_amount
    nil # cannot top up from the web store checkout
  end
end
