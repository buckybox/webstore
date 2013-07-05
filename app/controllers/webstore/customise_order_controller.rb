class Webstore::CustomiseOrderController < Webstore::BaseController
  def customise_order
    render 'customise_order', locals: {
      order: current_order.decorate,
      customise_order: Webstore::CustomiseOrder.new(cart: current_cart)
    }
  end

  def save_order_customisation
    args = { cart: current_cart }.merge(params[:webstore_customise_order])
    customise_order = Webstore::CustomiseOrder.new(args)
    customise_order.save ? successful_order_customisation : failed_order_customisation(customise_order)
  end

private

  def successful_order_customisation
    redirect_to webstore_customer_authorisation_path
  end

  def failed_order_customisation(customise_order)
    flash[:alert] = 'We\'re sorry there was an error customising your order.'
    render 'customise_order', locals: {
      order: current_order.decorate,
      customise_order: customise_order,
    }
  end
end
