# frozen_string_literal: true

require_relative "../../lib/schedule_rule"

describe ScheduleRule do
  let(:schedule) { ScheduleRule.new(frequency: :monthly, start_date: "2014-09-10", days: { 10 => 1, 13 => 1 }) }

  before { I18n.locale = :en }

  describe "#delivery_days" do
    specify { expect(schedule.delivery_days).to eq "Wednesday and Saturday" }
  end

  describe "#to_s" do
    specify { expect(schedule.to_s).to eq "Deliver monthly on the second Wednesday and Saturday" }
  end
end
