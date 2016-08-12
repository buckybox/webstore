# frozen_string_literal: true

class StoreController < CheckoutController
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

    product_id = params[:product_id]
    checkout.add_product!(product_id) ? successful_new_checkout(checkout) : failed_new_checkout
  end

private

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
