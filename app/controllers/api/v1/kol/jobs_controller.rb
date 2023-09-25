class Api::V1::Kol::JobsController < Api::V1::Kol::BaseController
  before_action :prepare_job, only: %i[apply finish payment complete cancle]

  def index
    jobs = policy_scope([:kol, Job])
    pagy, jobs = pagy(jobs, page: page_number, items: page_size)
    render json: JobSerializer.new(jobs, { meta: pagy_metadata(pagy) }), status: 200
  end

  def apply
    authorize @job, policy_class: Kol::JobPolicy
    if @job.status == 'booking' || @job.status == 'post'
      if @job.update(status: 'apply')
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
end
