class AuthenticationController < ApplicationController
  def authentication
    render 'authentication', locals: {
      order: current_order,
      authentication: Authentication.new(cart: current_cart)
    }
  end

  def save_authentication
    args = { cart: current_cart }.merge(params[:webstore_authentication])
    return if cart_expired?(args)
    authentication = Authentication.new(args)
    authentication.sign_in_attempt? ? try_sign_in(authentication) : save_credentials(authentication)
  end

private

  def try_sign_in(authentication)
    customer = attempt_customer_sign_in(authentication.email, authentication.password, no_track: current_admin.present?)
    handle_customer(customer)
    customer ? save_credentials(authentication) : failed_authentication(authentication)
  end

  def handle_customer(customer)
    current_webstore_customer.associate_real_customer(customer) if customer
  end

  def save_credentials(authentication)
    authentication.save ? successful_authentication : failed_authentication(authentication)
  end

  def successful_authentication
    redirect_to next_step
  end

  def failed_authentication(authentication)
    flash[:alert] = t('authentication.bad_email_password')
    render 'authentication', locals: {
      order: current_order,
      authentication: authentication,
    }
  end

  def next_step
    webstore_delivery_options_path
  end
end
