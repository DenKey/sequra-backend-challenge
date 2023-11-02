# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderDisbursementService do
  subject { OrderDisbursementService.new(date).call }

  describe 'daily disbursement' do
    context 'without reaching last month limit' do
      let(:date) { Date.new(2023, 10, 11) }
      let(:date_day_before) { Date.new(2023, 10, 10) }
      let!(:merchant) { create(:merchant) }
      let!(:order1) { create(:order, merchant:, created_at: date_day_before, amount: 30.0) }
      let!(:order2) { create(:order, merchant:, created_at: date, amount: 25.0) }

      it 'creates valid count of disbursements' do
        expect { subject }.to change { Disbursement.count }.by(3)
      end

      it 'charges valid merchant fee' do
        subject
        disbursement = Disbursement.where(merchant_id: merchant, fee_type: :merchant_fee).last
        expect(disbursement.amount).to eq(24.75)
      end

      it 'charges valid service fee' do
        subject
        disbursement = Disbursement.where(merchant_id: merchant, fee_type: :service_fee).last
        expect(disbursement.amount).to eq(0.25)
      end

      it 'charges valid monthly fee' do
        subject
        disbursement = Disbursement.where(merchant_id: merchant, fee_type: :monthly_fee).last
        expect(disbursement.amount).to eq(15)
      end
    end

    context 'with reaching last month limit' do
      let(:date) { 1.days.ago.to_date }
      let!(:last_month_disbursement) do
        create(:disbursement,
               merchant:,
               operated_at: 1.month.ago,
               fee_type: :service_fee,
               amount: 100)
      end
      let!(:merchant) { create(:merchant, minimum_monthly_fee: 1) }
      let!(:order1) { create(:order, merchant:, created_at: 1.days.ago, amount: 121) }
      let!(:order2) { create(:order, merchant:, created_at: 1.days.ago, amount: 321) }
      let!(:order3) { create(:order, merchant:, created_at: 1.days.ago, amount: 66.12) }
      let!(:order4) { create(:order, merchant:, created_at: 1.days.ago, amount: 21.45) }
      let!(:order5) { create(:order, merchant:, created_at: 1.days.ago, amount: 212.1) }
      let!(:order6) { create(:order, merchant:, created_at: 1.days.ago, amount: 25.41) }
      let!(:order8) { create(:order, merchant:, created_at: 1.days.ago, amount: 33.12) }
      let!(:order9) { create(:order, merchant:, created_at: 1.days.ago, amount: 100.0) }
      let!(:order10) { create(:order, merchant:, created_at: 1.days.ago, amount: 100.0) }

      it 'creates valid count of disbursements' do
        expect { subject }.to change { Disbursement.count }.by(2)
      end

      it 'charges valid merchant fee' do
        subject
        disbursement = Disbursement.where(merchant_id: merchant, fee_type: :merchant_fee).last
        expect(disbursement.amount).to eq(990.99)
      end

      it 'charges valid service fee' do
        subject
        disbursement = Disbursement.where(merchant_id: merchant, fee_type: :service_fee).last
        expect(disbursement.amount).to eq(9.21)
      end

      it 'changes orders disbursed status' do
        subject
        expect(Order.non_disbursed.count).to eq(0)
      end
    end

    context 'disbursed this month' do
      let(:date) { Date.new(2023, 10, 12) }
      let!(:last_month_disbursement) do
        create(:disbursement,
               merchant:,
               operated_at: Date.new(2023, 10, 10),
               fee_type: :service_fee,
               amount: 100)
      end
      let!(:merchant) { create(:merchant) }
      let!(:order1) { create(:order, merchant:, created_at: date, amount: 100.0) }

      it 'creates valid count of disbursements' do
        expect { subject }.to change { Disbursement.count }.by(2)
      end
    end
  end

  describe 'weekly disbursement' do
    context 'without reaching last month limit' do
      let(:date) { Date.new(2023, 10, 9) } # monday
      let(:date_week_ago) { Date.new(2023, 10, 2) } # monday
      let(:live_on) { Date.new(2023, 9, 4) } # monday
      let!(:merchant) { create(:merchant, :weekly, live_on:) }
      let!(:order1) { create(:order, merchant:, created_at: date_week_ago, amount: 30.0) }
      let!(:order2) { create(:order, merchant:, created_at: date_week_ago + 1.day, amount: 2.0) }
      let!(:order3) { create(:order, merchant:, created_at: date_week_ago + 2.days, amount: 3.0) }
      let!(:order4) { create(:order, merchant:, created_at: date_week_ago + 3.days, amount: 4.0) }
      let!(:order5) { create(:order, merchant:, created_at: date_week_ago + 4.days, amount: 2.0) }
      let!(:order6) { create(:order, merchant:, created_at: date_week_ago + 5.days, amount: 1.0) }
      let!(:order7) { create(:order, merchant:, created_at: date_week_ago + 6.days, amount: 2.0) }

      it 'creates valid count of disbursements' do
        expect { subject }.to change { Disbursement.count }.by(3)
      end

      it 'changes orders disbursed status' do
        subject
        expect(Order.non_disbursed.count).to eq(0)
      end
    end

    context 'with reaching last month limit' do
      let(:date) { Date.new(2023, 10, 9) } # monday
      let(:date_week_ago) { Date.new(2023, 10, 2) } # monday
      let(:live_on) { Date.new(2023, 9, 4) } # monday
      let!(:last_month_disbursement) do
        create(:disbursement,
               merchant:,
               operated_at: 1.month.ago,
               fee_type: :service_fee,
               amount: 100)
      end
      let!(:merchant) { create(:merchant, :weekly, live_on:, minimum_monthly_fee: 5) }
      let!(:order1) { create(:order, merchant:, created_at: date_week_ago, amount: 30.0) }
      let!(:order2) { create(:order, merchant:, created_at: date_week_ago + 1.day, amount: 20.0) }
      let!(:order3) { create(:order, merchant:, created_at: date_week_ago + 2.days, amount: 393.0) }
      let!(:order4) { create(:order, merchant:, created_at: date_week_ago + 3.days, amount: 40.0) }
      let!(:order5) { create(:order, merchant:, created_at: date_week_ago + 4.days, amount: 223.0) }
      let!(:order6) { create(:order, merchant:, created_at: date_week_ago + 5.days, amount: 123.0) }
      let!(:order7) { create(:order, merchant:, created_at: date_week_ago + 6.days, amount: 212.0) }

      it 'creates valid count of disbursements' do
        expect { subject }.to change { Disbursement.count }.by(2)
      end
    end
  end
end
