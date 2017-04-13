# frozen_string_literal: true

require_relative "phone_collection"

class Address
  ADDRESS_ATTRIBUTES = %i[
    address_1
    address_2
    suburb
    city
    postcode
    delivery_note
  ].freeze

  attr_accessor(*ADDRESS_ATTRIBUTES)
  attr_accessor(*PhoneCollection.attributes)

  def self.address_attributes
    ADDRESS_ATTRIBUTES
  end

  def initialize(args = {})
    args.each { |k, v| public_send("#{k}=", v) }
  end

  def to_s(join_with = ", ")
    ADDRESS_ATTRIBUTES.map do |attribute|
      public_send attribute
    end.reject(&:blank?).join(join_with).html_safe # rubocop:disable Rails/OutputSafety
  end

  def phones
    @phones ||= PhoneCollection.new(self)
  end

  def default_phone_number
    phones.default_number
  end

  def default_phone_type
    phones.default_type
  end

  # Handy helper to update a given number type
  def phone=(phone)
    type = phone[:type]
    number = phone[:number]
    return if type.blank?

    send("#{type}_phone=", number)
  end
end
