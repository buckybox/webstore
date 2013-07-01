require 'virtus'
require_relative '../webstore'

class Webstore::Form
  include Virtus
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def initialize(attributes = nil)
    @persisted = false
    super(attributes)
  end

  def save
    cart.add_order_information(self)
    self.persisted = cart.save
  end

  def persisted?
    persisted
  end

private

  attr_accessor :persisted
end
