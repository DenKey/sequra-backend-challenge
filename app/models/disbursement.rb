class Disbursement < ApplicationRecord
  has_many :orders
  belongs_to :merchant

  validates :amount, presence: true

  before_save :set_reference

  enum type: {
    merchant: 0,
    order_fee: 1,
    monthly_fee: 2
  }

  private

  def set_reference
    self.reference = SecureRandom.uuid
  end
end
