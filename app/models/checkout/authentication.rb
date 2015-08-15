require_relative '../form'

class Authentication < Form
  NEW_CUSTOMER = 'new'
  EXISTING_CUSTOMER = 'returning'

  attribute :email,       String
  attribute :registered,  String, default: NEW_CUSTOMER
  attribute :password,    String

  validates :email, presence: true, format: /.+@.+\..+/i

  delegate :webstore_id, to: :cart

  def options
    [
      [I18n.t('authentication.new_customer'),      NEW_CUSTOMER],
      [I18n.t('authentication.existing_customer'), EXISTING_CUSTOMER],
    ]
  end

  def sign_in_attempt?
    registered == EXISTING_CUSTOMER || Customer.exists?(email: email)
  end

  def default_option
    options.first.last
  end

  def to_h
    {
      email: email,
    }
  end
end
