module Webstore::SetupWebstoreHelpers
  def setup_a_webstore(product = nil)
    @distributor ||= Fabricate(:distributor)
    add_required_elements(product)
    activate_webstore
    @distributor.save
  end

private

  def activate_webstore
    @distributor.active_webstore = true
  end

  def add_required_elements(product = nil)
    product ||= add_a_product
    add_bank_information
    add_a_route
  end

  def add_a_product
    Fabricate(:box, distributor: @distributor)
  end

  def add_bank_information
    Fabricate(:bank_information, distributor: @distributor)
  end

  def add_a_route
    Fabricate(:route, distributor: @distributor)
  end
end
