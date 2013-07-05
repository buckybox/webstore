require 'virtus'
require_relative '../webstore'

class Webstore::Form
  include Virtus
  extend ActiveModel::Naming
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
