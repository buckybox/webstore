# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :new_relic_ignore_pingdom

private

  def new_relic_ignore_pingdom
    NewRelic::Agent.ignore_transaction if request.user_agent =~ /pingdom/i
  end
end
