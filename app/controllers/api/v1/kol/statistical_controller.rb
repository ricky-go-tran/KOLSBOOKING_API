class Api::V1::Kol::StatisticalController < Api::V1::Kol::BaseController
  def index_month
    kol_id = current_user.profile.kol_profile.id
    total_job = Job.total_current_month(kol_id:)
    finish_job = Job.status_current_month(kol_id:, status: 'finish')
    cancle_job = Job.status_current_month(kol_id:, status: 'cancle')
    profit = CalculatorPriceJobService.call(finish_job)
    render json: { total_job: total_job.count, finish_job: finish_job.count, cancle_job: cancle_job.count, profit: }
  end
end
