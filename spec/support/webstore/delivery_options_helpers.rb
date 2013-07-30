module Webstore::DeliveryOptionsHelpers
  shared_examples_for 'it needs a route' do
  end

  shared_examples_for 'it asks for a delivery date' do
    it 'has a delivey date field' do
      expect(page).to have_content('When would you like it?')
      expect(page.has_selector?('#webstore_delivery_options_start_date')).to be_true
    end
  end

  shared_examples_for 'it asks for a delivery frequency' do
    it 'has a frequency field' do
      expect(page).to have_content('Repeat delivery?')
      expect(page.has_selector?('#webstore_delivery_options_frequency')).to be_true
    end

    it 'has a date selector' do
      expect(page).to have_content('Sun')
      expect(page).to have_content('Mon')
      expect(page).to have_content('Tue')
      expect(page).to have_content('Wed')
      expect(page).to have_content('Thu')
      expect(page).to have_content('Fri')
      expect(page).to have_content('Sat')
    end
  end

  shared_examples_for 'it asks for an extras frequency' do
  end

  shared_examples_for 'it is on the delivery options page' do
    it_behaves_like 'it asks for a delivery date'
    it_behaves_like 'it asks for a delivery frequency'
  end
end
