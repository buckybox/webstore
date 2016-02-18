# frozen_string_literal: true

module ApplicationHelper
  def render_flash_messages(flash)
    flash.map do |type, message|
      content_tag(:div, class: "alert #{alert_class_for(type)}") do
        link_to("×", "javascript:void(0)", class: "close", data: { dismiss: "alert" }) << message
      end
    end.join.html_safe
  end

  private def alert_class_for(flash_type)
    {
      success: 'alert-success',
      error:   'alert-danger',
      alert:   'alert-warning',
      notice:  'alert-info',
    }[flash_type.to_sym] || flash_type.to_s
  end
end
