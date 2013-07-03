require_relative 'form'
require_relative '../webstore'

class Webstore::CustomerAuthorisation < Webstore::Form
  attribute :cart
  attribute :email,     String
  attribute :password,  String

  def options
    [
      ["I'm a new customer", 'new'],
      ["I'm a returning customer", 'returning'],
    ]
  end

  def default_option
    options.first.last
  end

  def distributor_parameter_name
    cart.distributor_parameter_name
  end
end

