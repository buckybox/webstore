require 'draper'
require_relative '../../models/delivery_service'

class Webstore::DeliveryServiceDecorator < Draper::Decorator
  delegate_all

  def instructions
    h.simple_format(object.instructions)
  end

  def schedule_input_id
    "delivery_service-schedule-inputs-#{object.id}"
  end
end
