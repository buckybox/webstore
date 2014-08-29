class CompletedController < BaseController
  def completed
    cart = flush_current_cart!

    if cart
      render 'completed', locals: {
        completed: Completed.new(
          cart:          cart,
          real_order:    real_order(cart),
          real_customer: real_customer(cart),
        ),
        cart: cart.decorate(
          context: { currency: current_distributor.currency }
        ),
        order: cart.order.decorate(
          context: { currency: current_distributor.currency }
        )
      }

    else # they likely refreshed the page
      redirect_to customer_dashboard_path
    end
  end

private

  def real_order(cart)
    ::Order.find(cart.real_order_id)
  end

  def real_customer(cart)
    ::Customer.find(cart.real_customer_id)
  end
end

