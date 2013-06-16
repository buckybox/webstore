require 'draper'
require_relative '../../models/webstore/order'
require_relative '../extra_decorator'

class Webstore::OrderDecorator < Draper::Decorator
  delegate_all

  def box_price
    object.box_price.format
  end

  def extras_price
    object.extras_price.format
  end

  def delivery_fee
    object.delivery_fee.format
  end

  def bucky_fee
    object.bucky_fee.format
  end

  def discount
    object.discount.format
  end

  def total
    object.total.format
  end

  def extras(extra_decorator = ExtraDecorator)
    e = object.extras
    extra_decorator.decorate_collection(e)
  end

  def exclusions_string
    ''
  end

  def substitutions_string
    ''
  end

  def extras_description
    ''
    # @extras_description_mem = extras.map do |id, count|
    #   extra_object = extra_objects.find { |extra| extra.id == id.to_i }
    #   "#{count}x #{extra_object.name} #{extra_object.unit}"
    # end.join(', ')
    #
    # if schedule_rule && !schedule_rule.frequency.single?
    #   @extras_description_mem += (extras_one_off? ? ', include in the next delivery only' : ', include with every delivery')
    # end
  end
end
