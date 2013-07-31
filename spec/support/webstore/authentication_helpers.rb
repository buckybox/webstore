module Webstore::AuthenticationHelpers
  shared_examples_for 'it is on the customer authorisation page' do
    it 'has a field to enter your email address' do
      expect(page.has_field?('Enter your e-mail address')).to be_true
    end

    it 'has the options to be a new or returning user' do
      expect(page.has_field?('I\'m a new customer')).to be_true
      expect(page.has_field?('I\'m a returning customer')).to be_true
    end
  end
end
