# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    reference { "christiansen_o'keefe" }
    email { "info@christiansen-o'keefe.com" }
    live_on { '07-10-2022' }
    disbursement_frequency { 'daily' }
    minimum_monthly_fee { 15.00 }
  end

  trait :weekly do
    disbursement_frequency { 'weekly' }
    live_on { Date.today }
  end
end
