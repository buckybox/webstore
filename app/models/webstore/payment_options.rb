require_relative 'form'
require_relative '../webstore'

class Webstore::PaymentOptions < Webstore::Form
  attribute :cart
end
