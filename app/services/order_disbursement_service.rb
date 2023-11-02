class OrderDisbursementService
  WEEK = 7.days

  # In normal case date will be 'Yesterday'
  def initialize(date)
    @date = date
  end

  def call
    # Active merchants that have orders in selected date
    # we should avoid to check of entire list of merchants
    daily_active_merchants.each do |merchant|
      calculate(merchant, @date)
    end

    weekly_active_merchants.each do |merchant|
      calculate(merchant, (@date - WEEK)..@date)
    end

    true
  end

  private

  def calculate(merchant, date)
    orders = orders_by_date(merchant, date)
    return if orders.empty?
    create_disbursement!(merchant, orders)
  end

  # Merchants that have active orders
  def daily_active_merchants
    Order.by_date(@date).includes(:merchant).where(merchant: { disbursement_frequency: :daily }).map(&:merchant).uniq
  end

  # Merchants with weekly disbursement
  def weekly_active_merchants
    Merchant.where(disbursement_frequency: :weekly).filter {|m| m.live_on.wday == @date.wday }
  end

  def orders_by_date(merchant, date)
    merchant.orders.by_date(date).non_disbursed
  end

  # Calculating range for current month
  def this_month
    month = Date.new(@date.year, @date.month)
    month.at_beginning_of_month..month.at_end_of_month
  end

  # Calculating range for previous month
  def previous_month
    date = @date - 1.month
    month = Date.new(date.year, date.month)
    month.at_beginning_of_month..month.at_end_of_month
  end

  # We shouldn't charge previous month before live_on
  def merchant_first_month?(merchant)
    (@date.at_beginning_of_month..@date.at_end_of_month).include?(merchant.live_on)
  end

  def create_disbursement!(merchant, orders)
    ActiveRecord::Base.transaction do
      create_monthly_fee!(merchant)

      service_fee = orders.map(&:service_fee).inject(0, &:+)
      merchant_fee = orders.map(&:merchant_fee).inject(0, &:+)

      Disbursement.create!(merchant: merchant, amount: service_fee, fee_type: :service_fee, operated_at: @date)
      Disbursement.create!(merchant: merchant, amount: merchant_fee, fee_type: :merchant_fee, operated_at: @date)

      orders.update_all(disbursed: true)
    end
  end

  def create_monthly_fee!(merchant)
    return if merchant_first_month?(merchant)
    return if Disbursement.disbursed_this_month?(merchant, this_month)
    disbursements = Disbursement.by_month(merchant.id, previous_month).where(fee_type: :service_fee)
    disbursements_fee = disbursements.map(&:amount).inject(0, &:+)
    return if disbursements_fee > merchant.minimum_monthly_fee

    monthly_fee = merchant.minimum_monthly_fee - disbursements_fee
    Disbursement.create!(merchant: merchant, amount: monthly_fee, fee_type: :monthly_fee, operated_at: @date)
  end
end
