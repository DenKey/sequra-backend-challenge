# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    reference { "christiansen_o'keefe" }
    amount { 100.0 }
    created_at { Date.today }

    association :merchant, factory: :merchant
  end
end
