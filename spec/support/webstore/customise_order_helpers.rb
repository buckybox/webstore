module Webstore::CustomiseOrderHelpers
  shared_examples_for 'it has exclusions' do
    it 'can be customised' do
      product.dislikes = true
      product.save
      click_button 'Order'
      expect(page).to have_content('Customise my box')
    end
  end

  shared_examples_for 'it has extras' do
    it 'extras can be added' do
      product.extras_limit = -1
      product.save
      click_button 'Order'
      expect(page).to have_content('Add any amount of extra items')
    end
  end

  shared_examples_for 'it is on the customise page' do
    it 'displays the product' do
      click_button 'Order'
      expect(page).to have_content(product_name)
      expect(page).to have_content(product_description)
      expect(page).to have_content(product_price)
    end

    context 'ordering a product that allows exclusions' do
      it_behaves_like 'it has exclusions'
    end

    context 'ordering a product that allows extras' do
      it_behaves_like 'it has extras'
    end

    context 'ordering a product that allows both exclusions and extras' do
      it_behaves_like 'it has exclusions'
      it_behaves_like 'it has extras'
    end
  end
end
