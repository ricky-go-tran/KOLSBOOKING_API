class Api::V1::Base::JobsController < Api::V1::Base::BaseController
  before_action :prepare_job, only: %i[update cancle show edit]

  def index
    search = params[:search]
    tab = params[:tab]
    jobs = policy_scope([:base, Job]).order(created_at: :desc)
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
    authorize @job, policy_class: Base::JobPolicy
    render json: JobWithEmojiSerializer.new(@job), status: 200
  end

  def create
    industry_associations_json = params[:job][:industry_associations_attributes]
    industry_associations = JSON.parse(industry_associations_json)
    params[:job][:industry_associations_attributes] = industry_associations
    job = Job.new(job_params)
    job.status = 'post'
    if job.save
      render json: JobSerializer.new(job), status: 201
    else
      render json: { errors: job.errors.full_messages }, status: 422
    end
  end

  def booking
    industry_associations_json = params[:job][:industry_associations_attributes]
    industry_associations = JSON.parse(industry_associations_json)
    params[:job][:industry_associations_attributes] = industry_associations
    job = Job.new(job_booking_params)
    job.status = 'booking'
    if job.save
      render json: JobSerializer.new(job), status: 201
    else
      render json: { errors: job.errors.full_messages }, status: 422
    end
  end

  def edit
    authorize @job, policy_class: Base::JobPolicy
    render json: JobWithIndustryAssociationSerializer.new(@job), status: 200
  end

  def update
    authorize @job, policy_class: Base::JobPolicy
    industry_associations_json = params[:job][:industry_associations_attributes]
    industry_associations = JSON.parse(industry_associations_json)
    params[:job][:industry_associations_attributes] = industry_associations
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

  def job_params
    params.require(:job).permit!
  end

  def job_booking_params
    params.require(:job).permit!
  end
end
