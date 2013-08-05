require 'draper'
require_relative '../../models/webstore/customer'

class Webstore::CustomerDecorator < Draper::Decorator
  delegate_all

  GUEST_NAME = 'Guest'

  def balance_threshold
    object.balance_threshold.format
  end

  def name
    object.guest? ? GUEST_NAME : object.name
  end
end
