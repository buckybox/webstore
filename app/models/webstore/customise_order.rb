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

  def exclusions?
    box.dislikes?
  end

  def substitutions?
    box.likes?
  end

  def extras_allowed?
    box.extras_allowed?
  end

  def extras_unlimited?
    box.extras_unlimited?
  end

  def exclusions_limit
    box.exclusions_limit
  end

  def substitutions_limit
    box.substitutions_limit
  end

  def extras_limit
    box.extras_limit
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
    attributes["extras"].delete_if { |key, value| value.to_i.zero? } if attributes["extras"]
    attributes
  end

  def box
    cart.box
  end
end
