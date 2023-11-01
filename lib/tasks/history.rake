namespace :history do
  desc 'Calculate historical disbursements'
  task :calculate => :environment do
    puts 'Calculation started.'

    History::DataHandler.new.call

    puts "Calculation successfully completed. Added #{Disbursement.count} Disbursements records"
  end
end
