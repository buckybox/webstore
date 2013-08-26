require 'draper'
require_relative '../../models/delivery_service'

class Webstore::DeliveryServiceDecorator < Draper::Decorator
  delegate_all

  def area_of_service
    h.simple_format(object.area_of_service)
  end

  def estimated_delivery_time
    h.simple_format(object.estimated_delivery_time)
  end

  def description
    result = object.area_of_service
    result += "\n\n" + object.estimated_delivery_time
    h.simple_format(result.html_safe)
  end

  def schedule_input_id
    "delivery_service-schedule-inputs-#{object.id}"
  end
end
