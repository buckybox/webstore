class StoreController < BaseController
  def home
    home = Home.new(
      distributor: current_distributor,
      existing_customer: current_customer,
    )

    @current_webstore_customer = home.customer.decorate

    render 'home', locals: {
      webstore_products: ProductDecorator.decorate_collection(home.products)
    }
  end

  def start_checkout
    checkout = Checkout.new(
      distributor_id: current_distributor.id,
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
    redirect_to next_step
  end

  def failed_new_checkout
    flash[:alert] = t('oops')
    redirect_to webstore_store_path
  end

  def next_step
    return webstore_customise_order_path if current_order.customisable?

    current_webstore_customer.guest? ? webstore_authentication_path : webstore_delivery_options_path
  end
end
