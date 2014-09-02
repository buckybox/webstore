require_relative 'cart'

class CartPersistence
  # TODO Redis store
  # serialize :collected_data
  def self.find_by(*args)
    nil
  end

  def self.create
    new
  end

  def id
    42
  end

  def update_attributes(*args)
    true
  end
end
