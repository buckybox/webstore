class MapController < ActionController::Base
  ensure_security_headers # secure_headers Gem

  protect_from_forgery with: :exception

  def index
    # show lightbox once a week
    if cookies[:skip_lightbox].to_i != 1
      cookies[:skip_lightbox] = {
        value: cookies[:skip_lightbox].nil? ? 0 : 1,
        expires: 1.week.from_now
      }
    end
  end
end
