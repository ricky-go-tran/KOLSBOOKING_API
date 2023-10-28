class Api::V1::Base::JobsController < Api::V1::Base::BaseController
  before_action :prepare_job, only: %i[update cancle show edit]
  before_action :handle_params, only: %i[update create booking]

  def index
    search = params[:search]
    tab = params[:tab]
    jobs = policy_scope([:base, Job]).order(created_at: :desc)
    jobs = jobs.search_by_title(search) if search.present?
    jobs = jobs.where_get_by_status(tab).order(created_at: :desc) if tab.present? && tab != 'all'
    pagy, jobs = pagy(jobs, page: page_number, items: page_size)
    render json: JobSerializer.new(jobs, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    authorize @job, policy_class: Base::JobPolicy
    render json: JobWithEmojiSerializer.new(@job), status: 200
  end

  def create
    create_or_booking('post')
  end

  def booking
    create_or_booking('booking')
  end

  def edit
    authorize @job, policy_class: Base::JobPolicy
    render json: JobWithIndustryAssociationSerializer.new(@job), status: 200
  end

  def update
    authorize @job, policy_class: Base::JobPolicy
    if @job.status == 'post'
      if @job.update(job_params)
        render json: JobSerializer.new(@job), status: 200
      else
        render json: { errors: @job.errors.full_messages }, status: 422
      end
    else
      render json: { errors: ['Job status must be post'] }, status: 422
    end
  end

  def cancle
    authorize @job, policy_class: Base::JobPolicy
    if @job.status != 'cancle' && @job.status != 'finish' && check_params
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

  def create_or_booking(status)
    job = Job.new(job_params)
    job.status = status
    if check_params
      if job.save
        render json: JobSerializer.new(job), status: 201
      else
        render json: { errors: job.errors.full_messages }, status: 422
      end
    end
  end

  def check_params
    job_params.key?(:title) && job_params.key?(:description) && job_params.key?(:industry_associations_attributes)
  end

  def job_params
    params.require(:job).permit!
  end

  def handle_params
    @industry_associations_json = params[:job][:industry_associations_attributes]
    @industry_associations = JSON.parse(@industry_associations_json)
    params[:job][:industry_associations_attributes] = @industry_associations
  end
end
