class Webstore::PaymentOptionsController < Webstore::BaseController
  def payment_options
    render 'payment_options', locals: {
      order: current_order.decorate,
      payment_options: Webstore::PaymentOptions.new(cart: current_cart)
    }
  end

  def save_payment_options
    args = { cart: current_cart }.merge(params[:webstore_payment_options])
    payment_options = Webstore::PaymentOptions.new(args)
    payment_options.save ? successful_payment_options : failed_payment_options(payment_options)
  end

private

  def successful_payment_options
    # Temp reminder. Do this when it makes sense
    #CustomerLogin.track(@webstore_order.customer) unless current_admin.present?
    redirect_to webstore_completed_path, notice: 'Your order has been placed.'
  end

  def failed_payment_options(payment_options)
    flash[:alert] = 'We\'re sorry there was an error saving your payment options.'
    render 'payment_options', locals: {
      order: current_order.decorate,
      delivery_options: payment_options,
    }
  end
end