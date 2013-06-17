require 'active_attr'
require_relative '../webstore'

class Webstore::Customise
  include ActiveAttr::BasicModel

  def initialize(args = {})
    @order = args[:order]
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

  def stock_list
    ['Apples', 'Banannas', 'Oranges', 'Grapes', 'Eggs', 'Coffee']
  end

  def extras
    Extra.limit(5)
  end
end
