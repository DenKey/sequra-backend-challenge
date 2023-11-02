# frozen_string_literal: true

class Order < ApplicationRecord
  # Storing such kind of constants should be handled carefully cuz in case of changes
  # of values inside we should keep in codebase all previous states. It will help in data
  # reporting and allow to avoid discrepancy in future. This structure allow us to keep all
  # corresponding values in one place.
  FEE = {
    current: {
      ZERO_TO_FIFTY: 1,
      FIFTY_TO_THREE_HUNDREDS: 0.95,
      MORE_THAN_THREE_HUNDREDS: 0.85
    }
  }.freeze

  belongs_to :merchant

  validates :reference, :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  scope :disbursed, -> { where(disbursed: true) }
  scope :non_disbursed, -> { where(disbursed: false) }
  scope :by_date, lambda { |date|
    date = date.is_a?(Range) ? date : date.beginning_of_day..date.end_of_day
    where(created_at: date)
  }

  def service_fee
    case amount
    when 0.0..50.0
      (amount / 100) * FEE[:current][:ZERO_TO_FIFTY]
    when 50.0..300.0
      (amount / 100) * FEE[:current][:FIFTY_TO_THREE_HUNDREDS]
    else
      (amount / 100) * FEE[:current][:MORE_THAN_THREE_HUNDREDS]
    end.round(2)
  end

  def merchant_fee
    amount - service_fee
  end
end
