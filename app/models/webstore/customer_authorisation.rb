require_relative 'form'
require_relative '../webstore'

class Webstore::CustomerAuthorisation < Webstore::Form
  attribute :cart
  attribute :email,     String
  attribute :password,  String

  validates_presence_of :email

  AUTHORISATION_OPTIONS = [
    ["I'm a new customer",        'new'],
    ["I'm a returning customer",  'returning'],
  ].freeze

  def options
    AUTHORISATION_OPTIONS
  end

  def default_option
    options.first.last
  end

  def distributor_parameter_name
    cart.distributor_parameter_name
  end

  def to_h
    {
      email:     email,
      password:  password,
    }
  end
end

