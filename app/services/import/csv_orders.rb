module Import
  class CsvOrders
    def initialize(csv_path)
      @csv_path = csv_path
    end

    def call
      chunks = SmarterCSV.process(@csv_path, headers_in_file: true, chunk_size: 1000)

      Parallel.map(chunks) do |chunk|
        worker(chunk)
      end
    end

    def worker(array_of_hashes)
      # We need establish new connection per each thread
      ActiveRecord::Base.connection.reconnect!

      # Caching of Merchants {reference => id}
      merchants = Merchant.pluck(:reference, :id).to_h

      return if merchants.empty?

      # As alternative we can use Order.import instead. On my machine import taken 6 minutes.
      array_of_hashes.each do |row|
        Order.create!(
          reference: row[:merchant_reference],
          amount: row[:amount],
          created_at: row[:created_at].to_datetime,
          merchant_id: merchants[row[:merchant_reference]]
        )
      end
    end
  end
end
