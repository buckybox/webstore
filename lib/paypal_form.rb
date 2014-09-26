module PaypalForm

module_function

  def recurring_payment_params(frequency)
    # https://www.paypal.com/en/cgi-bin/webscr?cmd=_pdn_subscr_techview_outside
    # p3 - number of time periods between each recurrence
    # t3 - time period (D=days, W=weeks, M=months, Y=years)

    p3, t3 = \
    case frequency.to_sym
    when :weekly
      [1, "W"]
    when :fortnightly
      [2, "W"]
    when :monthly
      [1, "M"]
    else
      raise ArgumentError, "Invalid frequency for recurring_payment_params: #{frequency.inspect}"
    end

    OpenStruct.new(p3: p3, t3: t3).freeze
  end
end
