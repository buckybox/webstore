# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?, except: :ping

  def ping
    render plain: "Pong!"
  end

private

  def ssl_configured?
    !Rails.env.development? && !Rails.env.test?
  end
end
