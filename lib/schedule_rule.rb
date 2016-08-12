# frozen_string_literal: true

class ScheduleRule
  attr_accessor :frequency, :start_date, :days

  FREQUENCIES = %i(single weekly fortnightly monthly).freeze

  def initialize(frequency:, start_date:, days:)
    self.frequency = frequency.to_sym
    raise ArgumentError unless FREQUENCIES.include?(self.frequency)

    self.start_date = start_date.is_a?(Date) ? start_date : Date.parse(start_date)

    self.days = days.keys.map(&:to_i)
    raise ArgumentError if self.days.any? { |day| day.negative? || day > 27 }
  end

  def delivery_days
    I18n.t("date.day_names").select.each_with_index do |_day, index|
      runs_on index
    end.to_sentence
  end

  # e.g. [0, 3]
  def week_days
    days.map { |day| day % 7 }
  end

  def week
    (days.first / 7).floor
  end

  def runs_on(week_day_index)
    week_days.include?(week_day_index)
  end

  def to_s
    case frequency
    when :single
      "#{I18n.t('schedule_rule.deliver_on')} #{I18n.l(start_date, format: '%d %b')}"
    when :weekly
      "#{I18n.t('schedule_rule.deliver_weekly_on')} #{delivery_days}"
    when :fortnightly
      "#{I18n.t('schedule_rule.deliver_fornightly_on')} #{delivery_days}"
    when :monthly
      "#{I18n.t('schedule_rule.deliver_monthly_on')} #{week.succ.ordinalize_in_full} #{delivery_days}"
    end
  end

  def to_h
    attributes = %i(frequency start_date week_days)
    attributes << :week if frequency != :single

    attributes.each_with_object({}) do |attr, hash|
      hash[attr] = public_send(attr)
    end
  end
end
