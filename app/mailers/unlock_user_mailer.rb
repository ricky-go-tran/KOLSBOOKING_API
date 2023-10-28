class UnlockUserMailer < ApplicationMailer
  layout 'mailer'

  def unlock
    @user = User.find_by(id: params[:user_id])
    @profile = @user.profile
    mail(to: @user.email, subject: 'Your account has been unlocked')
  end

  def lock
    @user = User.find_by(id: params[:user_id])
    mail(to: @user.email, subject: 'Feedback on Your Account Lock')
  end
end
