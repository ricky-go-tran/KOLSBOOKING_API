class Api::V1::Kol::JobsController < Api::V1::Kol::BaseController
  before_action :prepare_job, only: %i[show apply finish payment complete cancle]

  def index
    search = params[:search]
    tab = params[:tab]
    jobs = policy_scope([:kol, Job]).order(created_at: :desc)
    if search.present?
      jobs = jobs.where('title LIKE ?', "%#{search}%")
    end
    if tab.present? && tab != 'all'
      jobs = jobs.where_get_by_status(tab).order(created_at: :desc)
    end
    pagy, jobs = pagy(jobs, page: page_number, items: page_size)
    render json: JobSerializer.new(jobs, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    authorize @job, policy_class: Kol::JobPolicy
    render json: JobWithEmojiSerializer.new(@job), status: 200
  end

  def apply
    if @job.status == 'booking' || @job.status == 'post'
      if @job.update(status: 'apply', kol_id: current_user.profile.id)
        render json: JobSerializer.new(@job), status: 200
      else
        render json: { errors: @job.errors.full_messages }, status: 422
      end
    else
      render json: { errors: [I18n.t('job.error.invalid_status')] }, status: 422
    end
  end

  def complete
    if @job.status == 'apply'
      if @job.update(status: 'complete')
        render json: JobSerializer.new(@job), status: 200
      else
        render json: { errors: @job.errors.full_messages }, status: 422
      end
    else
      render json: { errors: [I18n.t('job.error.invalid_status')] }, status: 422
    end
  end

  def payment
    if @job.status == 'complete'
      if @job.update(status: 'payment')
        notification = notification_generate(@job)
        notification.save
        render json: JobSerializer.new(@job), status: 200
      else
        render json: { errors: @job.errors.full_messages }, status: 422
      end
    else
      render json: { errors: [I18n.t('job.error.invalid_status')] }, status: 422
    end
  end

  def finish
    if @job.status == 'payment' || @job.status == 'complete'
      if @job.update(status: 'finish')
        render json: JobSerializer.new(@job), status: 200
      else
        render json: { errors: @job.errors.full_messages }, status: 422
      end
    else
      render json: { errors: [I18n.t('job.error.invalid_status')] }, status: 422
    end
  end

  def cancle
    if @job.status != 'cancle' && @job.status != 'finish'
      if @job.update(status: 'cancle')
        render json: JobSerializer.new(@job), status: 200
      else
        render json: { errors: @job.errors.full_messages }, status: 422
      end
    else
      render json: { errors: [I18n.t('job.error.invalid_status')] }, status: 422
    end
  end

  private

  def prepare_job
    @job = Job.find_by(id: params[:id])
  end

  def notification_generate(job)
    @notification = Notification.new(title: 'You have a invoice', description: 'Kol is completed your job. And you can payment now', type_notice: 'notification', sender_id: job.kol_id, receiver_id: job.profile_id)
  end
end
