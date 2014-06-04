module Webstore::AuthenticationHelpers
  shared_examples_for 'it is on the customer authorisation page' do
    it 'has a field to enter your email address' do
      expect(page.has_field?('Enter your e-mail address')).to be true
    end

    it 'has the options to be a new or returning user' do
      expect(page.has_field?('I\'m a new customer')).to be true
      expect(page.has_field?('I\'m a returning customer')).to be true
    end
  end
end
