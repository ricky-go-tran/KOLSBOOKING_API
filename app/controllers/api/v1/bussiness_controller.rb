class Api::V1::BussinessController < ApplicationController
  before_action :prepare_bussiness, only: %i[show]

  def index
    businesses = if params[:search].blank?
                   User.with_role(:base).includes(profile: [:followed, :follower, { avatar_attachment: :blob }]).joins(:profile).where("profiles.status = 'valid'")
                 else
                   User.with_role(:base).includes(profile: [:followed, :follower, { avatar_attachment: :blob }, :followed]).joins(:profile).where("profiles.status = 'valid' and profiles.fullname LIKE '%#{params[:search]}%' ")
                 end
    pagy, businesses = pagy(businesses, page: page_number, items: page_size)
    render json: BussinessByUserSerializer.new(businesses, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    if current_user.blank?
      render json: BussinessByProfileDetailSerializer.new(@business), status: 200
    else
      render json: BussinessByProfileDetailWithCurrentFollowSerializer.new(@business), status: 200
    end
  end

  private

  def prepare_bussiness
    @business = Profile.find_by(id: params[:id])
  end
end
