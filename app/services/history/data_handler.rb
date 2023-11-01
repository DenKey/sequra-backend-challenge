module History
  class DataHandler
    def call
      started_at = Order.order(:created_at).first.created_at.to_date
      ended_at = Order.order(:created_at).last.created_at.to_date

      # We should add additional week after last day to be sure that weekly merchants
      # will handle
      dates = (started_at..ended_at).each_slice(10).to_a

      Parallel.map(dates) do |date_slice|
        worker(date_slice)
      end
    end

    def worker(date_slice)
      # We need establish new connection per each thread
      ActiveRecord::Base.connection.reconnect!

      date_slice.each do |date|
        OrderDisbursementService.new(date).call
      end
    end
  end
end
