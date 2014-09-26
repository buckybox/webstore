class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_webstore

  if Rails.env.development? || Rails.env.test?
    analytical modules: [], use_session_store: true
  else
    analytical modules: [:google], use_session_store: true
  end

protected

  helper_method def current_webstore
    @webstore ||= API.webstore(current_webstore_id)
  end
  alias_method :set_current_webstore, :current_webstore

  helper_method def current_customers
    customers = session[:current_customers]
    return [] unless customers

    SuperRecursiveOpenStruct.new(
      JSON.parse(customers)
    ).freeze
  end

  helper_method def current_customer
    webstore_id = current_webstore_id
    current_customers.detect { |customer| customer.webstore_id == webstore_id }
  end

  def sign_out
    session[:current_customers] = nil
    redirect_to webstore_path
  end

private

  def current_webstore_id
    params[:webstore_id]
  end
end
