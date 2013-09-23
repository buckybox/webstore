class Webstore::BaseController < ApplicationController
  layout 'customer'

  before_filter :distributor_has_webstore?
  before_filter :setup_by_distributor
  before_filter :distributors_customer?
  before_filter :cart_missing?
  before_filter :cart_present?
  before_filter :cart_completed?

protected

  def current_distributor
    @distributor ||= Distributor.find_by(parameter_name: params[:distributor_parameter_name])
  end

  def current_cart
    @current_cart ||= Webstore::Cart.find(session[:cart_id])
  end

  def flush_current_cart!
    cart = current_cart.dup if current_cart

    session.delete(:cart_id)
    @current_cart = nil

    cart
  end

  def current_order
    @current_order ||= current_cart.order.decorate
  end

  def current_webstore_customer
    @current_webstore_customer ||= current_cart.customer.decorate
  end

  def distributors_customer?
    if current_customer && current_customer.distributor != current_distributor
      redirect_to webstore_store_path(
        distributor_parameter_name: current_customer.distributor.parameter_name
      )
    end
  end

  def distributor_has_webstore?
    unless current_distributor && current_distributor.active_webstore
      redirect_to Figaro.env.marketing_site_url
    end
  end

  def setup_by_distributor
    Time.zone = current_distributor.time_zone
    Money.default_currency = Money::Currency.new(current_distributor.currency)
  end

  def cart_missing?
    return if current_cart

    if !action.in?(%w(store start_checkout))
      redirect_to webstore_store_path, alert: "There is no ongoing order, please start one."
    end
  end

  def cart_present?
    return unless current_cart

    expected_step = current_cart.expected_next_step

    if expected_step && expected_step != request.path && action == "store"
      redirect_to expected_step,
        alert: "Please complete your current order before starting a new one."
    else
      current_cart.expected_next_step = next_step
    end
  end

  def cart_completed?
    if !action.in?(%w(store completed)) && current_cart && current_cart.completed?
      redirect_to webstore_store_path,
        alert: "This order has been completed, please start a new one."
    end
  end

private

  def action
    params[:action]
  end
end
