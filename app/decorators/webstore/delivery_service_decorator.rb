require 'draper'
require_relative '../../models/delivery_service'

class Webstore::DeliveryServiceDecorator < Draper::Decorator
  delegate_all

  def instructions
    text = object.instructions.gsub(/\r/, "").gsub(/\n+/, "\n") # we don't want multiple <p>
    h.simple_format(text)
  end

  def schedule_input_id
    "delivery_service-schedule-inputs-#{object.id}"
  end
end
