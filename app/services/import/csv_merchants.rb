# frozen_string_literal: true

module Import
  class CsvMerchants
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

      array_of_hashes.each do |row|
        Merchant.create!(
          reference: row[:reference],
          email: row[:email],
          live_on: row[:live_on].to_date,
          disbursement_frequency: row[:disbursement_frequency].downcase,
          minimum_monthly_fee: row[:minimum_monthly_fee]
        )
      end
    end
  end
end
