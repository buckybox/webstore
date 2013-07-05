require_relative 'form'
require_relative '../webstore'

class Webstore::CustomiseOrder < Webstore::Form
  attribute :cart
  attribute :has_customisations,  Boolean
  attribute :dislikes,            Array[Integer]
  attribute :likes,               Array[Integer]
  attribute :extras,              Hash[Integer => Integer]
  attribute :add_extra,           Boolean

  def stock_list
    cart.stock_list
  end

  def extras_list
    cart.extras_list
  end

  def dislikes?
    true
  end

  def likes?
    true
  end

  def extras_allowed?
    true
  end

  def extras_unlimited?
    false
  end

  def exclusions_limit
    3
  end

  def substitutions_limit
    3
  end

  def extras_limit
    3
  end

  def to_h
    {
      dislikes:  dislikes,
      likes:     likes,
      extras:    extras,
    }
  end

protected

  def sanitise_attributes(attributes)
    attributes["dislikes"].delete("") if attributes["dislikes"]
    attributes["likes"].delete("") if attributes["likes"]
    attributes
  end
end
