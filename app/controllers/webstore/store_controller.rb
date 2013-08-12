class Webstore::StoreController < Webstore::BaseController
  skip_before_filter :distributors_customer?

  def store
    store = Webstore::Store.new(
      distributor: current_distributor,
      existing_customer: logged_in_customer
    )

    @current_customer = store.customer.decorate

    render 'store', locals: {
      webstore_products: Webstore::ProductDecorator.decorate_collection(store.products)
    }
  end

  def start_checkout
    checkout = Webstore::Checkout.new(
      distributor_id: current_distributor.id,
      existing_customer: logged_in_customer
    )

    @current_customer = checkout.customer.decorate

    distributors_customer?

    product_id = params[:product_id]
    if checkout.add_product!(product_id)
      successful_new_checkout(checkout)
    else
      failed_new_checkout
    end
  end

  def completed
    render 'completed', locals: {
      order: current_order,
      completed: Webstore::Completed.new(cart: current_cart),
      cart: Webstore::PaymentDecorator.decorate(current_cart),
    }
  end

private

  def successful_new_checkout(checkout)
    session[:cart_id] = checkout.cart_id
    redirect_to next_step
  end

  def failed_new_checkout
    flash[:alert] = 'We\'re sorry there was an error starting your order.'
    redirect_to webstore_store_path
  end

  def next_step
    return webstore_customise_order_path if current_order.customisable?

    if current_customer.guest?
      webstore_authentication_path
    else
      webstore_delivery_options_path
    end
  end
end
