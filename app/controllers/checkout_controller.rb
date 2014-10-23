class CheckoutController < ApplicationController
  before_action :webstore_active?
  before_action :setup_webstore
  before_action :customer_valid?
  before_action :cart_missing?
  before_action :cart_present?
  before_action :cart_completed?

protected

  helper_method def current_cart
    return @current_cart if @current_cart

    current_cart = Cart.find(session[:cart_id])
    current_cart = current_cart.decorate(decorator_context) if current_cart

    @current_cart = current_cart
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

  def customer_valid?
    if current_customer && current_customer.webstore_id != current_webstore.id
      sign_out
    end
  end

  def webstore_active?
    unless current_webstore && current_webstore.active
      redirect_to Figaro.env.marketing_site_url
    end
  end

  def setup_webstore
    Time.zone = current_webstore.time_zone
  end

  def cart_missing?
    return if current_cart

    unless action.in?(%w(home start_checkout))
      redirect_to webstore_path, alert: t('no_ongoing_order')
    end
  end

  def cart_present?
    return unless current_cart

    if action == "home"
      flush_current_cart!
      flash.now[:notice] = t('cancelled_order')
    end
  end

  def cart_completed?
    if !action.in?(%w(home completed)) && current_cart && current_cart.completed?
      redirect_to webstore_path,
        alert: "This order has been completed, please start a new one."
    end
  end

  def cart_expired?(args)
    current_form_cart_id = args.fetch("cart_id")

    if !form_cart_id
      session[:form_cart_id] = current_form_cart_id

    elsif form_cart_id != current_form_cart_id
      flush_current_cart!

      redirect_to webstore_path,
        alert: "Sorry, this order has expired, please start a new one." and return true
    end

    false
  end

  def form_cart_id
    session[:form_cart_id]
  end

private

  def action
    params[:action]
  end

  def decorator_context
    {
      context: { currency: current_webstore.currency }
    }
  end
end
