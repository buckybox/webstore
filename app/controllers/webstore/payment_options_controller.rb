class Webstore::PaymentOptionsController < Webstore::BaseController
  def payment_options
    render "payment_options", locals: {
      order: current_order,
      payment_options: Webstore::PaymentOptions.new(cart: current_cart),
      cart: current_cart,
    }
  end

  def save_payment_options
    args = { cart: current_cart }.merge(params[:webstore_payment_options])
    payment_options = Webstore::PaymentOptions.new(args)
    payment_options.save ? successful_payment_options : failed_payment_options(payment_options)
  end

private

  def successful_payment_options
    webstore_factory = current_cart.run_factory
    customer_sign_in(webstore_factory.customer, no_track: current_admin.present?)

    redirect_to next_step, notice: "Your order has been placed."
  end

  def failed_payment_options(payment_options)
    flash[:alert] = "Oops there was an issue: " \
      << payment_options.errors.full_messages.join(", ").downcase

    render "payment_options", locals: {
      order: current_order,
      payment_options: payment_options,
      cart: current_cart,
    }
  end

  def next_step
    webstore_completed_path
  end
end
