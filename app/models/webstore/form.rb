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

  attribute :cart

  def initialize(attributes = {})
    attributes = sanitise_attributes(attributes)
    before_standard_initialize(attributes)
    super
    after_standard_initialize(attributes)
  end

  def save
    return false unless self.valid?
    cart.add_order_information(self)
    cart.save
  end

  def persisted?
    # It is due to how Rails form helpers act based on persistence
    # If it has persisted? == true then it tries to render the form as an edit and with edit URLs
    # this also goes back to the delivery_services with _index
    # if we wanted to change those we would also have to change that method to return 'true'
    # the forms would send PUT instead of POST
    # and we could take off the _index from some delivery_services
    # I tried this briefly but it didn't work out. Chose not to bother given time issues
    # don't think it is important or makes a difference for the webstore process
    # but I'm open to convincing if you feel strongly
    #
    # -- Samson Ootoovak

    false
  end

protected

  def cart_id
    cart.id
  end

  def sanitise_attributes(attributes)
    attributes
  end

  def before_standard_initialize(attributes)
    # just a NO OP hook
  end

  def after_standard_initialize(attributes)
    # just a NO OP hook
  end
end
