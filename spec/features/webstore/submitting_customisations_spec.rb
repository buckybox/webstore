require_relative "../../support/capybara/select2_helper"
require_relative "../../support/webstore/webstore_helper"

describe "submitting customisations" do
  include Select2Helper
  include Webstore::StoreHelpers

  before do
    get_to_customise_step
  end

  context "with exclusions" do
    before do
      check "Customise my box"
      select2 @dislike, from: "webstore_customise_order_dislikes"
    end

    it "displays them" do
      submit

      page.should have_content @dislike
    end

    context "with substitutes" do
      before do
        select2 @like, from: "webstore_customise_order_likes"
      end

      it "displays them" do
        submit

        page.should have_content @like
      end
    end
  end

  context "with extras" do
    before do
      check "Customise my box"
      select2 /^#{@extra}/, from: "webstore_customise_order_add_extra"
    end

    it "displays them" do
      submit

      page.should have_content @extra
    end
  end

  def get_to_customise_step
    make_a_webstore_with_products
    visit webstore_store_path(@distributor.parameter_name)
    customisable_product(product)
    click_button "Order"
  end

  def submit
    click_button "Next"
  end

  def customisable_product(product)
    @line_items = 2.times.map { Fabricate(:line_item, distributor: @distributor) }

    @extras = [ Fabricate(:extra, distributor: @distributor) ]
    Fabricate(:box_extra, extra: @extras[0], box: product)

    @dislike = @line_items[0].name
    @like = @line_items[1].name
    @extra = @extras[0].name

    product.dislikes            = true
    product.exclusions_limit    = -1
    product.likes               = true
    product.substitutions_limit = -1
    product.extras_limit        = -1
    product.save
  end
end
