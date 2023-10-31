namespace :import do
  desc 'Import Merchants'
  task :merchants => :environment do
    csv_path = Rails.root.join('lib', 'data', 'merchants.csv')

    puts 'Import started.'

    Import::CsvMerchants.new(csv_path).call

    puts "Import successfully completed. Added #{Merchant.count} Merchants"
  end

  desc 'Import Orders from CSV file'
  task :orders => :environment do
    csv_path = Rails.root.join('lib', 'data', 'orders.csv')

    puts 'Import started.(It might take near 6-7 minutes)'

    Import::CsvOrders.new(csv_path).call

    puts "Import successfully completed. Added #{Order.count} Orders"
  end
end
