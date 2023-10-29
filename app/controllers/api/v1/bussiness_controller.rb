class Api::V1::BussinessController < ApplicationController
  before_action :prepare_bussiness, only: %i[show]

  def index
    search = params[:search]
    filter = params[:filter]
    businesses = User.get_all_businesses_valid
    businesses = businesses.search_bussiness_by_fullname(search) if search.present?
    businesses = businesses.search_bussiness_by_status(filter) if filter.present? && filter != 'all'
    pagy, businesses = pagy(businesses, page: page_number, items: page_size)
    render json: BussinessByUserSerializer.new(businesses, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    authorize @business, policy_class: BussinessPolicy
    serializer = current_user.blank? ? BussinessByProfileDetailSerializer : BussinessByProfileDetailWithCurrentFollowSerializer
    render json: serializer.new(@business, { params: { profile_id: current_user.profile.id } }), status: 200
  end

  private

  def prepare_bussiness
    @business = Profile.find_by(id: params[:id])
  end
end
