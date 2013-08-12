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
    product.dislikes?
  end

  def substitutions?
    product.likes?
  end

  def extras_allowed?
    product.extras_allowed?
  end

  def extras_unlimited?
    product.extras_unlimited?
  end

  def exclusions_limit
    product.exclusions_limit
  end

  def substitutions_limit
    product.substitutions_limit
  end

  def extras_limit
    product.extras_limit
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
    attributes.fetch('dislikes', []).delete('')
    attributes.fetch('likes', []).delete('')
    extras_check = ->(key, value) { value.to_i.zero? }
    attributes.fetch('extras', {}).delete_if(&extras_check)
    attributes
  end

  def product
    cart.product
  end
end
