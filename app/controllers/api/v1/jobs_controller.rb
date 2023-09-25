class Api::V1::JobsController < ApplicationController
  def index
    jobs = policy_scope(Job)
    pagy, jobs = pagy(jobs, page: page_number, items: page_size)
    render json: JobWithEmojiSerializer.new(jobs, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    authorize @job, policy_class: JobPolicy
    render json: JobSerializer.new(@job), status: 200
  end

  private

  def prepare_job
    @job = Job.find_by(params[:id])
  end
end
