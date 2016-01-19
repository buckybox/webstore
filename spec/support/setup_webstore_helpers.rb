module SetupWebstoreHelpers
  def setup_a_webstore(product = nil)
    @distributor ||= double(:distributor)
    add_required_elements(product)
    activate_webstore
    @distributor.save
  end

private

  def activate_webstore
    @distributor.active_webstore = true
  end

  def add_required_elements(product = nil)
    add_a_product unless product
    add_bank_information
    add_a_delivery_service
  end

  def add_a_product
    double(:box, distributor: @distributor)
  end

  def add_bank_information
    double(:bank_information, distributor: @distributor)
  end

  def add_a_delivery_service
    double(:delivery_service, distributor: @distributor)
  end
end
