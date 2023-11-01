class OrderDisbursementService
  WEEK = 7.days

  # In normal case date will be 'Yesterday'
  def initialize(date)
    @date = date
  end

  def call
    # Active merchants that have orders in selected date
    # we should avoid to check of entire list of merchants
    merchants = Merchant.where(id: active_merchants_ids)

    merchants.each do |merchant|
      disbursement_frequency(merchant)
    end
  end

  private

  def disbursement_frequency(merchant)
    date = merchant.daily? ? @date : (@date - WEEK)..@date

    orders = orders_by_date(merchant, date)
    return if orders.empty?
    create_disbursement!(merchant, orders)
  end

  # Merchants Ids that have active orders
  def active_merchants_ids
    Order.by_date(@date).pluck(:merchant_id).uniq
  end

  def orders_by_date(merchant, date)
    merchant.orders.by_date(date).non_disbursed
  end

  # Calculating range for current month
  def this_month
    month = Date.new(@date.year, @date.month)
    month.at_beginning_of_month..month.at_end_of_month
  end

  # We shouldn't charge first month on live_on cuz it can be the last day of the month.
  # Generally it's a more business solution how to handle such cases
  def merchant_first_month?(merchant)
    (@date.at_beginning_of_month..@date.at_end_of_month).include?(merchant.live_on)
  end

  def create_disbursement!(merchant, orders)
    ActiveRecord::Base.transaction do
      @service_fee = orders.map(&:service_fee).inject(0, &:+)
      @merchant_fee = orders.map(&:merchant_fee).inject(0, &:+)

      Disbursement.create!(merchant: merchant, amount: @service_fee, fee_type: :service_fee, operated_at: @date)
      Disbursement.create!(merchant: merchant, amount: @merchant_fee, fee_type: :merchant_fee, operated_at: @date)

      create_monthly_fee!(merchant)

      orders.update_all(disbursed: true)
    end
  end

  def create_monthly_fee!(merchant)
    return if merchant_first_month?(merchant)
    return if Disbursement.disbursed_this_month?(merchant, this_month)
    return if @service_fee > merchant.minimum_monthly_fee

    monthly_fee = merchant.minimum_monthly_fee - @service_fee

    Disbursement.create!(merchant: merchant, amount: monthly_fee, fee_type: :monthly_fee, operated_at: @date)
  end
end
