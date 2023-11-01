class Disbursement < ApplicationRecord
  has_many :orders
  belongs_to :merchant

  validates :amount, presence: true
  validates :operated_at, uniqueness: { scope: [:merchant_id, :fee_type] }

  before_save :set_reference

  scope :disbursed_this_month?, ->(merchant, month_range) {
    where(merchant_id: merchant.id, created_at: month_range).any?
  }

  enum fee_type: {
    merchant_fee: 0,
    service_fee: 1,
    monthly_fee: 2
  }

  private

  def set_reference
    self.reference = SecureRandom.uuid
  end
end
