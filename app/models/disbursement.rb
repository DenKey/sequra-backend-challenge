class Disbursement < ApplicationRecord
  has_many :orders
  belongs_to :merchant

  validates :amount, presence: true
  validates :operated_at, uniqueness: { scope: [:merchant_id, :fee_type] }

  before_save :set_reference

  enum fee_type: {
    merchant_fee: 0,
    service_fee: 1,
    monthly_fee: 2
  }

  scope :by_month, ->(merchant_id, month_rage) { where(merchant_id: merchant_id, operated_at: month_rage) }

  def self.disbursed_this_month?(merchant, month_range)
    month_range.include?(where(merchant_id: merchant.id).last.created_at)
  end

  private

  def set_reference
    self.reference = SecureRandom.uuid
  end
end
