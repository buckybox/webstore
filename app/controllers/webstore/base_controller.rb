class Webstore::BaseController < ApplicationController
  layout 'customer'

  before_filter :distributor_has_webstore?
  before_filter :setup_by_distributor
  before_filter :distributors_customer?
  before_filter :cart_completed?

protected

  def current_distributor
    @distributor ||= Distributor.find_by(parameter_name: params[:distributor_parameter_name])
  end

  def current_cart
    @current_cart ||= Webstore::Cart.find(session[:cart_id])
  end

  def flush_current_cart!
    cart = current_cart.dup

    session.delete(:cart_id)
    @current_cart = nil

    cart
  end

  def current_order
    @current_order ||= current_cart.order.decorate
  end

  def current_customer
    return super unless current_cart
    @current_customer ||= current_cart.customer.decorate
  end

  def distributors_customer?
    return if current_customer.guest?

    valid_customer = (current_customer.distributor == current_distributor)
    alert_message = 'This account is not for this webstore. Please logout first then try your purchase again.'
    redirect_to webstore_store_path, alert: alert_message and return unless valid_customer
  end

  def distributor_has_webstore?
    active_webstore = !current_distributor.nil? && current_distributor.active_webstore
    redirect_to Figaro.env.marketing_site_url and return unless active_webstore
  end

  def setup_by_distributor
    Time.zone = current_distributor.time_zone
    Money.default_currency = Money::Currency.new(current_distributor.currency)
  end

  def cart_completed?
    if !params[:action].in?(%w(store completed)) && current_cart && current_cart.completed?
      redirect_to webstore_store_path,
        alert: "This order has been completed, please start a new one."
    end
  end
end
