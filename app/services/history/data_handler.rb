module History
  class DataHandler
    def call
      started_at = Order.order(:created_at).first.created_at.to_date
      ended_at = Order.order(:created_at).last.created_at.to_date

      # We should add additional week after last day to be sure that weekly merchants
      # will handle
      (started_at..(ended_at + 7.days)).each do |date|
        OrderDisbursementService.new(date).call
      end
    end
  end
end
