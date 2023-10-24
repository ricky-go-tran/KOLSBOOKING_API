class Api::V1::Base::BussinessProfilesController < Api::V1::Base::BaseController
  before_action :prepare_bussiness_profile, only: %i[change]

  def index
    @bussiness_profile = Profile.find_by(id: current_user.profile.id)
    render json: BussinessByProfileSerializer.new(@bussiness_profile), status: 200
  end

  def create
    @bussiness_profile = Bussiness.new(bussiness_profile_params)
    @bussiness_profile.profile_id = current_user.profile.id
    if @bussiness_profile.save
      render json: BussinessSerializer.new(@bussiness_profile), status: 201
    else
      render json: { errors: @bussiness_profile.errors.full_messages }, status: 422
    end
  end

  def change
    if @bussiness_profile.update(bussiness_profile_params)
      render json: { message: 'Success update' }, status: 200
    else
      render json: { errors: @bussiness_profile.errors.full_messages }, status: 422
    end
  end

  private

  def prepare_bussiness_profile
    @bussiness_profile = Bussiness.find_by(profile_id: current_user.profile.id)
  end

  def bussiness_profile_params
    params.require(:bussiness_profile).permit(:type_profile, :overview)
  end
end
