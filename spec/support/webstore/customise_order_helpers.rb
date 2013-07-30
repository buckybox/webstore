module Webstore::CustomiseOrderHelpers
  shared_examples_for 'it has exclusions' do
    it 'can be customised' do
      expect(page).to have_content('Customise my box')
    end
  end

  shared_examples_for 'it has extras' do
    it 'extras can be added' do
      expect(page).to have_content('Add any amount of extra items')
    end
  end

  shared_examples_for 'it is on the customise page' do
    it_behaves_like 'it has exclusions'
    it_behaves_like 'it has extras'
  end
end
