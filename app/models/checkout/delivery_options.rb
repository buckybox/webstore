require_relative '../form'

class DeliveryOptions < Form
  attribute :delivery_service, Integer
  attribute :start_date,       Date
  attribute :frequency,        String
  attribute :days,             Hash[Integer => Integer]
  attribute :extra_frequency,  Boolean

  validates_presence_of :delivery_service, :start_date, :frequency
  validates_presence_of :days, if: -> { frequency != "single" }

  delegate :has_extras?, to: :cart, prefix: true

  def existing_delivery_service_id
    customer.delivery_service_id
  end

  def can_change_delivery_service?
    !existing_delivery_service_id
  end

  def delivery_services
    API.delivery_services
  end

  def delivery_service_list
    delivery_services.map { |delivery_service| delivery_service_list_item(delivery_service) } \
      .unshift([I18n.t('delivery_options.select_delivery_service'), nil])
  end

  def single_delivery_service?
    delivery_services.one?
  end

  def single_delivery_service
    delivery_services.last
  end

  def order_frequencies
    [
      [I18n.t('delivery_options.order_frequencies.select'),      nil],
      [I18n.t('delivery_options.order_frequencies.weekly'),      :weekly],
      [I18n.t('delivery_options.order_frequencies.fortnightly'), :fortnightly],
      [I18n.t('delivery_options.order_frequencies.monthly'),     :monthly],
      [I18n.t('delivery_options.order_frequencies.single'),      :single]
    ]
  end

  def extra_frequencies
    [
      [I18n.t('delivery_options.extra_frequencies.always'), false],
      [I18n.t('delivery_options.extra_frequencies.once'),   true],
    ]
  end

  def to_h
    {
      delivery_service_id: delivery_service,
      start_date:          start_date,
      frequency:           frequency,
      days:                days,
      extra_frequency:     extra_frequency,
    }
  end

private

  def customer
    cart.customer
  end

  def delivery_service_list_item(delivery_service)
    [ delivery_service.name_days_and_fee, delivery_service.id ]
  end
end
