# frozen_string_literal: true

class CheckoutController < ApplicationController
  before_action :set_current_webstore
  before_action :set_locale
  before_action :webstore_active?
  before_action :setup_webstore
  before_action :customer_valid?
  before_action :cart_missing?
  before_action :cart_completed?

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

  def flush_current_cart!
    cart = current_cart.dup if current_cart

    session.delete(:cart_id)
    session.delete(:form_cart_id)
    @current_cart = nil

    cart
  end

  def current_order
    @current_order ||= current_cart.order.decorate(decorator_context)
  end

  def current_webstore_customer
    @current_webstore_customer ||= current_cart.customer.decorate
  end

  def cart_expired?(args)
    current_form_cart_id = args.fetch("cart_id")

    if !form_cart_id
      session[:form_cart_id] = current_form_cart_id

    elsif form_cart_id != current_form_cart_id
      flush_current_cart!

      redirect_to(webstore_path,
                  alert: "Sorry, this order has expired, please start a new one.") && (return true)
    end

    false
  end

  def form_cart_id
    session[:form_cart_id]
  end

private

  def webstore_active?
    unless current_webstore && current_webstore.active
      redirect_to Figaro.env.marketing_site_url
    end
  end

  def setup_webstore
    Time.zone = current_webstore.time_zone
  end

  def customer_valid?
    if current_customer && current_customer.webstore_id != current_webstore.id
      sign_out
    end
  end

  def cart_missing?
    return if current_cart

    redirect_to webstore_path, alert: t("no_ongoing_order")
  end

  def cart_completed?
    if current_cart && current_cart.completed?
      redirect_to webstore_path,
                  alert: "This order has been completed, please start a new one."
    end
  end

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

  def decorator_context
    {
      context: { currency: current_webstore.currency },
    }
  end
end
