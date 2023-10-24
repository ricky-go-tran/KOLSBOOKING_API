class Api::V1::BussinessController < ApplicationController
  before_action :prepare_bussiness, only: %i[show]

  def index
    search = params[:search]
    filter = params[:filter]
    businesses = User.with_role(:base).includes(profile: [:followed, :follower, { avatar_attachment: :blob }]).joins(:profile).where("profiles.status = 'valid'")
    if search.present?
      businesses = businesses.joins(:profile).where('profiles.fullname LIKE ?', "%#{search}%")
    end

    if filter.present? && filter != 'all'
      businesses = businesses.joins(profile: :bussiness).where('bussinesses.type_profile LIKE ?', "%#{filter}%")
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
