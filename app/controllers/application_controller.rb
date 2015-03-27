class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  before_action :set_current_webstore
  before_action :set_locale

  if Rails.env.development? || Rails.env.test?
    analytical modules: [], use_session_store: true
  else
    analytical modules: [:google], use_session_store: true
  end

protected

  helper_method def current_webstore
    @current_webstore ||= API.webstore(current_webstore_id)
  end

  helper_method def current_customers
    customers = session[:current_customers]
    return [] unless customers

    SuperRecursiveOpenStruct.new(
      JSON.parse(customers)
    ).freeze
  end

  helper_method def current_customer
    webstore_id = current_webstore_id
    current_customers.find { |customer| customer.webstore_id == webstore_id }
  end

  def sign_out
    session[:current_customers] = nil
    redirect_to webstore_path
  end

private

  def set_current_webstore
    current_webstore # fetch the actual web store and make sure it exists
  rescue BuckyBox::API::NotFoundError
    redirect_to "/404.html"
  end

  def current_webstore_id
    params[:webstore_id]
  end

  def set_locale
    I18n.locale = current_webstore.locale
  end
end
