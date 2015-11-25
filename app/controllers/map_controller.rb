class MapController < ActionController::Base
  ensure_security_headers # secure_headers Gem

  protect_from_forgery with: :exception

  def index
  end
end
