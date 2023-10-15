class Api::V1::KolsController < ApplicationController
  before_action :prepare_kol, only: %i[show]

  def index
    kols = if params[:search].blank?
             User.with_role(:kol).includes(profile: [:followed, :follower, { avatar_attachment: :blob }]).joins(:profile).where("profiles.status = 'valid'")
           else
             User.with_role(:kol).includes(profile: [:followed, :follower, { avatar_attachment: :blob }, :followed]).joins(:profile).where("profiles.status = 'valid' and profiles.fullname LIKE '%#{params[:search]}%' ")
           end
    pagy, kols = pagy(kols, page: page_number, items: page_size)
    render json: KolByUserSerializer.new(kols, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    check_present_record(@kol)
    authorize @kol, policy_class: KolPolicy
    if current_user.blank?
      render json: KolByProfileDetailSerializer.new(@kol), status: 200
    elsif current_user.has_role?(:base)
      profile_id = current_user.profile.id
      render json: KolByProfileDetailWithCurrentEmojiAndFollowSerializer.new(@kol, { params: { profile_id: } }), status: 200
    else
      profile_id = current_user.profile.id
      render json: KolByProfileDetailWithCurrentUserEmojiSerializer.new(@kol, { params: { profile_id: } }), status: 200
    end
  end

  private

  def prepare_kol
    @kol = Profile.find_by(id: params[:id])
  end
end
