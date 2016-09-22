# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?, except: :ping

  before_action :new_relic_ignore_pingdom

  def ping
    render text: "Pong!"
  end

private

  def ssl_configured?
    !Rails.env.development? && !Rails.env.test?
  end

  def new_relic_ignore_pingdom
    return unless request.user_agent =~ /pingdom|ELB-HealthChecker/i

    NewRelic::Agent.ignore_transaction
  end
end
