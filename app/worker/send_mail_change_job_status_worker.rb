class SendMailChangeJobStatusWorker
  include Sidekiq::Worker

  def perform(user_id, kol_id, job_id)
    ChangeStatusJobByKolMailer.with(user_id:, kol_id:, job_id:).change_status_job_by_kol.deliver_now
  end
end
