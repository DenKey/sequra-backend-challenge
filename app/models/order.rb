class Order < ApplicationRecord
  belongs_to :merchant

  validates :reference, :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end
