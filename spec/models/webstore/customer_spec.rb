require_relative '../../../app/models/webstore/customer'

describe Webstore::Customer do
  let(:args)     { { id: 1 } }
  let(:customer) { Webstore::Customer.new(args) }

  describe '.find' do
    it 'finds a customer based on an id' do
      new_customer = double('customer')
      Webstore::Customer.stub(:new) { new_customer }
      Webstore::Customer.find(1).should eq(new_customer)
    end
  end
end
