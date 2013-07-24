require 'virtus'
require 'active_model/naming'
require 'active_model/conversion'
require 'active_model/validations'
require 'active_model/translation'
require_relative '../webstore'

class Webstore::Form
  extend ActiveModel::Naming

  include Virtus
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def initialize(attributes = nil)
    attributes = sanitise_attributes(attributes)
    super(attributes)
  end

  def save
    cart.add_order_information(self)
    cart.save
  end

  def persisted?
    false
  end

protected

  def sanitise_attributes(attributes)
    attributes
  end
end
