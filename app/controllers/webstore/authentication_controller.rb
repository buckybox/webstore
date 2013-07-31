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
    authentication.save ? successful_authentication : failed_authentication(authentication)
  end

private

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
