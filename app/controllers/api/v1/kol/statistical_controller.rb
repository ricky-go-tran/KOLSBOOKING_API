class Api::V1::Kol::StatisticalController < Api::V1::Kol::BaseController
  def index
    kol_current_id = current_user.profile.id
    total_job = Job.total_current_month(kol_id: kol_current_id)
    finish_job = Job.status_current_month({ kol_id: kol_current_id, status: 'finish' })
    cancle_job = Job.status_current_month({ kol_id: kol_current_id, status: 'cancle' })
    finish_job_detail = Job.status_current_month_details({ kol_id: kol_current_id, status: 'finish' })
    cancel_job_detail = Job.status_current_month_details({ kol_id: kol_current_id, status: 'cancle' })
    profit = CalculatorPriceJobService.call(finish_job)

    @days_current_month = (Date.today.beginning_of_month..Date.today.end_of_month).to_a

    finish_job_detail_hash = Hash[@days_current_month.map { |day| [day.to_s, 0] }]
    finish_job_detail.each do |date, count|
      finish_job_detail_hash[date.to_s] = count
    end
    cancel_job_detail_hash = Hash[@days_current_month.map { |day| [day.to_s, 0] }]
    cancel_job_detail.each do |date, count|
      cancel_job_detail_hash[date.to_s] = count
    end

    render json: {
      label: finish_job_detail_hash.keys,
      total_job: total_job.count,
      finish_job: finish_job.count,
      finish_detail: finish_job_detail_hash.values,
      cancle_job: cancle_job.count,
      cancle_detail: cancel_job_detail_hash.values,
      profit:
    }
  end
end
