class SendMailUnlockUserWorker
  include Sidekiq::Worker

  def perform(user_id)
    UnlockUserMailer.with(user_id:).unlock.deliver_now
  end
end
