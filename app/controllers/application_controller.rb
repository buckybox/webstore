# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_current_webstore
  before_action :set_locale

protected

  helper_method def current_webstore
    @current_webstore ||= API.webstore(current_webstore_id)
  end

  helper_method def current_customers
    json = session[:current_customers] || "[]"
    customers = JSON.parse(json)
    customers.map { |customer| OpenStruct.new(customer).freeze }
  end

  helper_method def current_customer
    webstore_id = current_webstore_id
    current_customers.find { |customer| customer.webstore_id == webstore_id }
  end

  helper_method def current_cart
    @current_cart ||= begin
      current_cart = Cart.find(session[:cart_id])
      current_cart.decorate(decorator_context) if current_cart
    end
  end

  helper_method def customer_can_switch_account?
    !current_cart
  end

  def sign_out
    session[:current_customers] = nil
    redirect_to webstore_path
  end

private

  def set_current_webstore
    current_webstore # fetch the actual web store and make sure it exists
  rescue BuckyBox::API::NotFoundError
    render layout: false, file: "public/404.html", status: :not_found
  end

  def current_webstore_id
    params[:webstore_id]
  end

  def set_locale
    I18n.locale = current_webstore.locale
  end
end
