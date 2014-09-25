class CompletedController < ApplicationController
  def completed
    cart = flush_current_cart!

    if cart
      render 'completed', locals: {
        completed: Completed.new(cart: cart),
        cart: cart.decorate(
          context: { currency: current_webstore.currency }
        ),
        order: cart.order.decorate(
          context: { currency: current_webstore.currency }
        )
      }

    else # they likely refreshed the page
      redirect_to customer_dashboard_path
    end
  end
end
