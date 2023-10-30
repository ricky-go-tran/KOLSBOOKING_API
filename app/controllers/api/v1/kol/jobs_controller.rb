class Api::V1::Kol::JobsController < Api::V1::Kol::BaseController
  include ConstantHelper
  before_action :prepare_job, only: %i[show apply finish payment complete cancle]

  def index
    search = params[:search]
    tab = params[:tab]
    jobs = policy_scope([:kol, Job]).order(created_at: :desc)
    jobs = jobs.search_by_title(search) if search.present?
    jobs = jobs.where_get_by_status(tab).order(created_at: :desc) if tab.present? && JOBS_ACCEPTED_PARAMS.include?(tab)
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
    authorize @job, policy_class: Kol::JobPolicy
    condition = (@job.status == 'apply')
    update_status(@job, condition, 'complete')
  end

  def payment
    authorize @job, policy_class: Kol::JobPolicy
    condition = (@job.status == 'complete')
    update_status(@job, condition, 'payment')
  end

  def finish
    authorize @job, policy_class: Kol::JobPolicy
    condition = (@job.status == 'payment' || @job.status == 'complete')
    update_status(@job, condition, 'finish')
  end

  def cancle
    authorize @job, policy_class: Kol::JobPolicy
    condition = (@job.status != 'cancle' && @job.status != 'finish')
    update_status(@job, condition, 'cancle')
  end

  private

  def prepare_job
    @job = Job.find_by(id: params[:id])
  end

  def update_status(job, condition, status)
    if condition
      if job.update(status:)
        notification_generate(job) if status == 'payment'
        render json: JobSerializer.new(@job), status: 200
      else
        render json: { errors: @job.errors.full_messages }, status: 422
      end
    else
      render json: { errors: [I18n.t('job.error.invalid_status')] }, status: 422
    end
  end

  def notification_generate(job)
    notification = Notification.new(title: 'You have a invoice', description: 'Kol is completed your job. And you can payment now', type_notice: 'notification', sender_id: job.kol_id, receiver_id: job.profile_id)
    notification.save
  end
end
