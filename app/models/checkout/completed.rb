require_relative '../form'

class Completed < Form
  delegate :webstore, to: :cart
  delegate :customer, to: :cart
  delegate :name, to: :customer, prefix: true
  delegate :email, to: :customer, prefix: true
  delegate :number, to: :customer, prefix: true
  delegate :payment_method, to: :cart
  delegate :amount_due, to: :cart
  delegate :bank_information, to: :webstore
  delegate :bank_name, to: :bank_information

  def customer_address
    customer.address.join('<br>')
  end

  def schedule_description
    order.schedule_rule
  end

  def product_name
    order.box.name
  end

  def payment_recurring?
    !schedule_rule.one_off?
  end

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
      webstore.cod_payment_message
    end
  end

  def bank_account_name
    bank_information.account_name
  end

  def bank_account_number
    bank_information.account_number
  end

  def note
    bank_information.customer_message
  end
end
