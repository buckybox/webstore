require_relative '../webstore'

class Webstore::Customer
  attr_reader :id

  def initialize(args)
    @id = args[:id]
  end

  def self.find(id)
    new(id: id)
  end
end
