# frozen_string_literal: true

require_relative '../customer'

class Home
  def initialize(args = {})
    @webstore          = args.fetch(:webstore)
    @existing_customer = args.fetch(:existing_customer)
  end

  def products
    @products ||= API.boxes
  end

  def customer(customer_class = Customer)
    @customer ||= customer_class.new(
      existing_customer_id: existing_customer && existing_customer.id
    )
  end

private

  attr_reader :webstore
  attr_reader :existing_customer
end
