class Webstore::BaseController < ApplicationController
  layout 'customer'

  before_filter :distributor_has_webstore?
  before_filter :setup_by_distributor
  before_filter :distributors_customer?

protected

  def current_distributor
    @distributor ||= Distributor.where(parameter_name: params[:distributor_parameter_name]).first
    raise "Unknown distributor" unless @distributor
    @distributor
  end

  def current_cart
    @current_cart ||= Webstore::Cart.find(session[:cart_id])
  end

  def current_order
    @current_order ||= current_cart.order.decorate
  end

  alias_method :logged_in_customer, :current_customer
  def current_customer
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
end
