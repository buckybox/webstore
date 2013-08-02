require 'draper'
require_relative '../../models/webstore/customer'

class Webstore::CustomerDecorator < Draper::Decorator
  delegate_all

  def balance_threshold
    object.balance_threshold.format
  end
end
