require 'active_record'
require_relative 'cart'

class CartPersistence < ActiveRecord::Base
  serialize :collected_data
  attr_accessible :collected_data
end
