class Api::V1::JobsController < ApplicationController
  before_action :prepare_job, only: %i[show]

  def index
    jobs = policy_scope(Job)
    pagy, jobs = pagy(jobs, page: page_number, items: page_size)
    if current_user.blank?
      render json: JobWithEmojiSerializer.new(jobs, { meta: pagy_metadata(pagy) }), status: 200
    elsif current_user.has_role?(:kol)
      profile = current_user.profile
      kol_profile_id = profile.kol_profile.id
      render json: JobWithCurrentUserEmojiAndBookmarkSerializer.new(jobs, { params: { profile_id: profile.id, kol_id: kol_profile_id }, meta: pagy_metadata(pagy) }), status: 200
    else
      profile_id = current_user.profile.id
      render json: JobWithCurrentUserEmojiSerializer.new(jobs, { params: { profile_id: }, meta: pagy_metadata(pagy) }), status: 200
    end
  end

  def show
    authorize @job, policy_class: JobPolicy
    if current_user.blank?
      render json: JobWithEmojiSerializer.new(@job), status: 200
    elsif current_user.has_role?(:kol)
      profile = current_user.profile
      kol_profile_id = profile.kol_profile.id
      render json: JobWithCurrentUserEmojiSerializer.new(@job, { params: { profile_id: profile.id, kol_id: kol_profile_id } }), status: 200
    else
      profile_id = current_user.profile.id
      render json: JobWithCurrentUserEmojiSerializer.new(@job, { params: { profile_id: } }), status: 200
    end
  end

  private

  def prepare_job
    @job = Job.find_by(id: params[:id])
  end
end