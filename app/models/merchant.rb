class Merchant < ApplicationRecord
  has_many :disbursements
  has_many :orders

  validates :disbursement_frequency, :live_on, :reference, :email, presence: true
  validates :minimum_monthly_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum disbursement_frequency: {
    daily: 0,
    weekly: 1
  }
end
