# frozen_string_literal: true

class StoreController < CheckoutController
  skip_before_action :cart_missing?, only: %i[home start_checkout]
  skip_before_action :cart_completed?, only: :home
  before_action :cart_present?, only: :home

  def home
    home = Home.new(
      webstore: current_webstore,
      existing_customer: current_customer,
    )

    @current_webstore_customer = home.customer.decorate
    products = ProductDecorator.decorate_collection(home.products, context: { webstore: current_webstore })

    render "home", locals: { products: products }
  end

  def start_checkout
    checkout = Checkout.new(
      webstore_id: current_webstore.id,
      existing_customer: current_customer,
    )

    return if cart_expired?("cart_id" => checkout.cart_id)

    @current_webstore_customer = checkout.customer.decorate

    product_id = params.permit(:product_id)[:product_id]
    checkout.add_product!(product_id) ? successful_new_checkout(checkout) : failed_new_checkout
  end

private

  def cart_present?
    return unless current_cart

    flush_current_cart!
    flash.now[:notice] = t("cancelled_order")
  end

  def successful_new_checkout(checkout)
    session[:cart_id] = checkout.cart_id
    redirect_to(*next_step)
  end

  def failed_new_checkout
    flash[:alert] = t("oops")
    redirect_to webstore_path
  end

  def next_step
    return webstore_path, alert: t("oops") if current_order.invalid?
    return customise_order_path if current_order.customisable?

    current_webstore_customer.guest? ? authentication_path : delivery_options_path
  end
end
