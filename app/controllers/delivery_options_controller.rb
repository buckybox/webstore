# frozen_string_literal: true

class DeliveryOptionsController < CheckoutController
  def delivery_options
    delivery_options = DeliveryOptions.new(cart: current_cart)
    render 'delivery_options', locals: {
      order: current_order,
      delivery_services: DeliveryServiceDecorator.decorate_collection(delivery_options.delivery_services),
      delivery_options: delivery_options,
    }
  end

  def save_delivery_options
    args = { cart: current_cart }.merge(params[:delivery_options])
    return if cart_expired?(args)
    delivery_options = DeliveryOptions.new(args)
    delivery_options.save ? successful_delivery_options : failed_delivery_options(delivery_options)
  end

private

  def successful_delivery_options
    redirect_to next_step
  end

  def failed_delivery_options(delivery_options)
    flash[:alert] = t('oops') << t('colon') <<
                    delivery_options.errors.full_messages.join(", ").downcase

    render "delivery_options", locals: {
      order: current_order,
      delivery_services: DeliveryServiceDecorator.decorate_collection(delivery_options.delivery_services),
      delivery_options: delivery_options,
    }
  end

  def next_step
    payment_options_path
  end
end
