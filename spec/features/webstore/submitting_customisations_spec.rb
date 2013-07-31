require_relative '../../support/capybara/select2_helper'
require_relative '../../support/webstore/webstore_helper'

describe 'submitting customisations' do
  include Select2Helper
  include Webstore::StoreHelpers

  before { pending; get_to_customise_step }

  describe 'only selected exclustions' do
    before do
      check 'Customise my box'
      select2 @line_items[0].name, from: 'webstore_customise_order_dislikes'
    end

    it 'shows the order so far' do
    end
  end

  describe 'selected exclustions and substitutions' do
    it 'shows the order so far' do
    end

  end

  describe 'selected extras' do
    it 'shows the order so far' do
    end

  end

  describe 'seleted exclustions, substitutions, and extras' do
    it 'shows the order so far' do
    end

  end

  def get_to_customise_step
    make_a_webstore_with_products
    visit webstore_store_path(@distributor.parameter_name)
    customisable_product(product)
    click_button 'Order'
  end

  def customisable_product(product)
    @extras = []
    @line_items = []
    2.times { @extras << Fabricate(:extra, distributor: @distributor) }
    4.times { @line_items << Fabricate(:line_item, distributor: @distributor) }
    @extras.each { |extra| Fabricate(:box_extra, extra: extra, box: product) }
    product.likes        = true
    product.dislikes     = true
    product.extras_limit = -1
    product.save
  end
end
