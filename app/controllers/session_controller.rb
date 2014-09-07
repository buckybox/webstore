class SessionController < ActionController::Base
  # TODO: inherit from ApplicationController
  protect_from_forgery with: :exception

  def new
  end

  def create
    credentials = params[:session]

    API.webstore_id = current_webstore_id
    result = API.authenticate_customer(credentials, as_object: false)

    if result.nil?
      redirect_to customer_sign_in_path, alert: "Nope"
    else
      session[:current_customers] = result
      redirect_to webstore_path
    end
  end

  def destroy
    session[:current_customers] = nil
    redirect_to webstore_path
  end

private

  def current_webstore_id
    params[:webstore_id]
  end

end
