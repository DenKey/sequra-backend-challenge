namespace :import do
  desc 'Import Merchants'
  task :merchants => :environment do
    csv_path = Rails.root.join('lib', 'data', 'merchants.csv')

    puts 'Merchants import started.'

    Import::CsvMerchants.new(csv_path).call

    puts "Merchants import successfully completed. Added #{Merchant.count} Merchants"
  end

  desc 'Import Orders'
  task :orders => :environment do
    csv_path = Rails.root.join('lib', 'data', 'orders.csv')

    puts 'Orders import started.(It might take near 6-7 minutes)'

    Import::CsvOrders.new(csv_path).call

    puts "Orders import successfully completed. Added #{Order.count} Orders"
  end

  desc 'Import all data'
  task :all => :environment do
    Rake::Task["import:merchants"].invoke
    Rake::Task["import:orders"].invoke
  end
end
