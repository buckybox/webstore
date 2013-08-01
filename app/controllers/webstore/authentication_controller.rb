class Webstore::AuthenticationController < Webstore::BaseController
  def authentication
    render 'authentication', locals: {
      order: current_order.decorate,
      authentication: Webstore::Authentication.new(cart: current_cart)
    }
  end

  def save_authentication
    args = { cart: current_cart }.merge(params[:webstore_authentication])
    authentication = Webstore::Authentication.new(args)
    authentication.sign_in_attempt? ? try_sign_in(authentication) : save_credentials(authentication)
  end

private

  def try_sign_in(authentication)
    customer = attempt_customer_sign_in(authentication.email, authentication.password, no_track: current_admin.present?)
    handle_customer(customer)
    !!customer ? save_credentials(authentication) : failed_authentication(authentication)
  end

  def handle_customer(customer)
    current_customer.associate_real_customer(customer) if !!customer
  end

  def save_credentials(authentication)
    authentication.save ? successful_authentication : failed_authentication(authentication)
  end

  def successful_authentication
    redirect_to webstore_delivery_options_path
  end

  def failed_authentication(authentication)
    flash[:alert] = 'We\'re sorry there was an error with your credentials.'
    render 'authentication', locals: {
      order: current_order.decorate,
      authentication: authentication,
    }
  end
end
