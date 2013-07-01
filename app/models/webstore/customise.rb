require 'virtus'
require_relative '../webstore'

class Webstore::Customise
  include Virtus
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :cart
  attribute :has_customisations, Boolean
  attribute :dislikes, Array[String]
  attribute :likes, Array[String]
  attribute :extras, Hash[Integer => Integer]
  attribute :add_extra, Boolean

  def save
    binding.pry
    true
  end

  def persisted?
    false
  end

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
end
