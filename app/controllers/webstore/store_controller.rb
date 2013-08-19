class Webstore::StoreController < Webstore::BaseController
  def store
    store = Webstore::Store.new(
      distributor: current_distributor,
      existing_customer: current_customer,
    )

    @current_webstore_customer = store.customer.decorate

    render 'store', locals: {
      webstore_products: Webstore::ProductDecorator.decorate_collection(store.products)
    }
  end

  def start_checkout
    checkout = Webstore::Checkout.new(
      distributor_id: current_distributor.id,
      existing_customer: current_customer,
    )

    @current_webstore_customer = checkout.customer.decorate

    product_id = params[:product_id]
    if checkout.add_product!(product_id)
      successful_new_checkout(checkout)
    else
      failed_new_checkout
    end
  end

  def completed
    cart = flush_current_cart!

    if cart
      render 'completed', locals: {
        completed: Webstore::Completed.new(
          cart: cart.decorate,
          real_order: ::Order.find(cart.real_order_id),
          real_customer: ::Customer.find(cart.real_customer_id),
        )
      }

    else # they likely refreshed the page
      redirect_to customer_dashboard_path
    end
  end

private

  def successful_new_checkout(checkout)
    session[:cart_id] = checkout.cart_id
    redirect_to next_step
  end

  def failed_new_checkout
    flash[:alert] = "Oops there was an issue, please review the error below."
    redirect_to webstore_store_path
  end

  def next_step
    return webstore_customise_order_path if current_order.customisable?

    if current_webstore_customer.guest?
      webstore_authentication_path
    else
      webstore_delivery_options_path
    end
  end
end
