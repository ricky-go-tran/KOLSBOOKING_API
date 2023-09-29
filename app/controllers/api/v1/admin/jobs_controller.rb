class Api::V1::Admin::JobsController < Api::V1::Admin::BaseController
  before_action :prepare_job, only: %i[show cancle]

  def index
    jobs = Job.all.includes(:profile)
    pagy, jobs = pagy(jobs, page: page_number, items: page_size)
    render json: JobSerializer.new(jobs, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    render json: JobWithEmojiSerializer.new(@job), status: 200
  end

  def cancle
    if @job.status == 'cancle'
      render json: { errors: [I18n.t('job.error.already_cancel')] }, status: 422
    elsif @job.update(status: 'cancle')
      render json: JobSerializer.new(@job), status: 200
    else
      render json: { errors: @job.errors.full_messages }, status: 422
    end
  end

  private

  def prepare_job
    @job = Job.find_by(id: params[:id])
  end
end
