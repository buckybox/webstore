require 'active_record'
require_relative '../webstore'
require_relative 'cart'

class Webstore::CartPersistance < ActiveRecord::Base
  serialize :collected_data, JSON
  attr_accessible :collected_data

  def collected_data
    read_attribute(:collected_data).with_indifferent_access
  end
end
