require 'virtus'
require 'active_model/naming'
require 'active_model/conversion'
require 'active_model/validations'
require 'active_model/translation'

class Form
  extend ActiveModel::Naming

  include Virtus.model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :cart

  delegate :id, to: :cart, prefix: true

  def initialize(attributes = {})
    attributes = sanitize_attributes(attributes)
    before_standard_initialize(attributes)
    super
    after_standard_initialize(attributes)
  end

  def save
    return false unless self.valid?

    cart.add_order_information(self)
    cart.save
  end

  # So SimpleForm infers the right paths and POST method
  def persisted?
    false
  end

  # Overwrite i18n_scope from activemodel/lib/active_model/translation.rb
  def self.i18n_scope
    :virtus
  end

protected

  def sanitize_attributes(attributes)
    attributes
  end

  def before_standard_initialize(attributes)
    # just a NO OP hook
  end

  def after_standard_initialize(attributes)
    # just a NO OP hook
  end
end
