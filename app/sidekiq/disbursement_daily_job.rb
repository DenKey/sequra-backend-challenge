# Generate Disbursement by previous date
class DisbursementDailyJob
  include Sidekiq::Job

  def perform
    OrderDisbursementService.new(Date.yesterday).call
  end
end
