# frozen_string_literal: true

require "draper"

class DeliveryServiceDecorator < Draper::Decorator
  delegate_all

  def instructions
    text = object.instructions.delete("\r").gsub(/\n+/, "\n") # we don't want multiple <p>
    h.simple_format(text)
  end

  def schedule_input_id
    "delivery_service-schedule-inputs-#{object.id}"
  end

  def start_dates
    object.start_dates.map do |human_date, iso_date, attributes|
      [human_date, iso_date, attributes.to_h]
    end
  end
end
