# frozen_string_literal: true

class PaymentOptionsController < CheckoutController
  def payment_options
    render "payment_options", locals: {
      order: current_order,
      payment_options: PaymentOptions.new(cart: current_cart),
      cart: current_cart,
    }
  end

  def save_payment_options
    args = { cart: current_cart }.merge(params[:payment_options])
    return if cart_expired?(args)
    payment_options = PaymentOptions.new(args)
    payment_options.save ? successful_payment_options : failed_payment_options(payment_options)
  end

private

  def successful_payment_options
    current_cart.run_factory
    # webstore_factory = current_cart.run_factory
    # customer_sign_in(webstore_factory.customer) # TODO: authenticate new customers here

    redirect_to next_step, notice: t("order_placed")
  end

  def failed_payment_options(payment_options)
    flash[:alert] = t("oops") << t("colon") <<
                    payment_options.errors.full_messages.join(", ").downcase

    render "payment_options", locals: {
      order: current_order,
      payment_options: payment_options,
      cart: current_cart,
    }
  end

  def next_step
    completed_path
  end
end
