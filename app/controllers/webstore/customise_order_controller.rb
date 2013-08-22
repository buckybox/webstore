class Webstore::CustomiseOrderController < Webstore::BaseController
  def customise_order
    render "customise_order", locals: {
      order: current_order,
      customise_order: Webstore::CustomiseOrder.new(cart: current_cart),
    }
  end

  def save_order_customisation
    args = { cart: current_cart }.merge(params[:webstore_customise_order])
    customise_order = Webstore::CustomiseOrder.new(args)
    customise_order.save ? successful_order_customisation : failed_order_customisation(customise_order)
  end

private

  def successful_order_customisation
    redirect_to next_step
  end

  def next_step
    if current_webstore_customer.guest?
      webstore_authentication_path
    else
      webstore_delivery_options_path
    end
  end

  def failed_order_customisation(customise_order)
    flash[:alert] = "Oops there was an issue: " \
      << customise_order.errors.values.join(", ").downcase

    render "customise_order", locals: {
      order: current_order,
      customise_order: customise_order,
    }
  end
end
