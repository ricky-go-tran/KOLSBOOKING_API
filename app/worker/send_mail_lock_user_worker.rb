class SendMailLockUserWorker
  include Sidekiq::Worker

  def perform(user_id)
    UnlockUserMailer.with(user_id:).lock.deliver_now
  end
end
