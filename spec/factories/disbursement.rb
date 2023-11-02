# frozen_string_literal: true

FactoryBot.define do
  factory :disbursement do
    amount { 23.34 }
    operated_at { Date.today }
    fee_type { :merchant_fee }

    association :merchant, factory: :merchant
  end
end
