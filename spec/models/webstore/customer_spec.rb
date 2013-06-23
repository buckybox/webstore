require_relative '../../../app/models/webstore/customer'

describe Webstore::Customer do
  let(:args)     { { id: 1 } }
  let(:customer) { Webstore::Customer.new(args) }

  describe '.find' do
    xit 'finds a customer based on an id' do
    end
  end
end
