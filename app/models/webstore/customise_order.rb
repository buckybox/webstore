require_relative 'form'
require_relative '../webstore'

class Webstore::CustomiseOrder < Webstore::Form
  attribute :cart
  attribute :has_customisations,  Boolean
  attribute :dislikes,            Array[Integer]
  attribute :likes,               Array[Integer]
  attribute :extras,              Hash[Integer => Integer]
  attribute :add_extra,           Boolean

  validate :number_of_exclusions
  validate :number_of_substitutions
  validate :number_of_extras

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
    [ product.exclusions_limit.to_i, 0 ].max
  end

  def substitutions_limit
    [ product.substitutions_limit.to_i, 0].max
  end

  def extras_limit
    [ product.extras_limit.to_i, 0 ].max
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

  def exclusions_count
    dislikes.size || 0
  end

  def substitutions_count
    likes.size || 0
  end

  def extras_count
    extras.values.inject(&:+) || 0
  end

  def number_of_exclusions
    if exclusions? && exclusions_count > exclusions_limit
      errors.add(:dislikes, "you have too many exclusions the maximum is #{exclusions_limit}")
    end
  end

  def number_of_substitutions
    if substitutions? && substitutions_count > substitutions_limit
      errors.add(:likes, "you have too many substitutions the maximum is #{substitutions_limit}")
    end
  end

  def number_of_extras
    if !extras_unlimited? && extras_count > extras_limit
      errors.add(:extras, "you have too many extras the maximum is #{extras_limit}")
    end
  end
end
