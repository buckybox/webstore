require_relative '../../../app/models/webstore/customer'

describe Webstore::Customer do
  let(:distributor)      { double('distributor') }
  let(:existing_customer){ double('existing_customer') }
  let(:customer)         { Webstore::Customer.new }

  describe '#existing_delivery_service_id' do
    it 'returns a delivery_service id' do
      customer.stub(:existing_customer).and_return(existing_customer)
      existing_customer.stub_chain(:delivery_service, :id).and_return(3)
      existing_customer.stub(:active?).and_return(false)
      customer.delivery_service_id.should eq(3)
    end
  end
end
