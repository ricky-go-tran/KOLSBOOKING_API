class ChangeStatusJobByKolMailer < ApplicationMailer
  layout 'mailer'

  def change_status_job_by_kol
    @user = User.find_by(id: params[:user_id])
    @profile = @user.profile
    @job = Job.find_by(id: params[:job_id])
    @kol = Profile.find_by(id: params[:kol_id])
    mail(to: @user.email, subject: 'Change Status Job By Kol')
  end
end
