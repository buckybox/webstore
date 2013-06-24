require 'active_record'
require_relative '../webstore'
require_relative 'cart'

class Webstore::CartPersistance < ActiveRecord::Base
  serialize :collected_data
  attr_accessible :collected_data
end
