# Class to store multiple phone numbers
# Each number is associated with a type (mobile, home, work)
class PhoneCollection
  TYPES = %w(mobile home work).inject({}) do |hash, type|
    hash.merge!(type => "#{type}_phone")
  end.freeze

  def self.attributes
    TYPES.values
  end

  def self.types_as_options
    TYPES.each_key.map { |type| type_option(type) }
  end

  def initialize address
    @address = address
  end

  def all
    TYPES.each_value.map do |attribute|
      phone = @address.send(attribute)

      [
        I18n.t("models.phone_collection.#{attribute}"),
        I18n.t('colon'),
        phone
      ].join unless phone.blank?
    end.compact
  end

  def default_number
    @address.send(default[:attribute])
  end

  def default_type
    default[:type]
  end

private

  def self.type_option(type)
    [ I18n.t("models.phone_collection.#{type}_phone"), type ]
  end

  def default
    TYPES.each do |type, attribute|
      number = @address.public_send(attribute)
      return { type: type, attribute: attribute } if number.present?
    end

    # fallback to first type if all blank
    type, attribute = TYPES.first
    { type: type, attribute: attribute }
  end
end

