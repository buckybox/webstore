class Webstore::DeliveryOptionsController < Webstore::BaseController
  def delivery_options
    delivery_options = Webstore::DeliveryOptions.new(cart: current_cart)
    render 'delivery_options', locals: {
      order: current_order,
      routes: Webstore::RouteDecorator.decorate_collection(delivery_options.routes),
      delivery_options: delivery_options,
    }
  end

  def save_delivery_options
    args = { cart: current_cart }.merge(params[:webstore_delivery_options])
    delivery_options = Webstore::DeliveryOptions.new(args)
    delivery_options.save ? successful_delivery_options : failed_delivery_options(delivery_options)
  end

private

  def successful_delivery_options
    redirect_to webstore_payment_options_path
  end

  def failed_delivery_options(delivery_options)
    flash[:alert] = "Oops there was an issue: " \
      << delivery_options.errors.full_messages.join(", ").downcase

    render "delivery_options", locals: {
      order: current_order,
      routes: Webstore::RouteDecorator.decorate_collection(delivery_options.routes),
      delivery_options: delivery_options,
    }
  end
end
