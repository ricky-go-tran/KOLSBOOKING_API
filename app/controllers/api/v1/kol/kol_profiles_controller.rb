class Api::V1::Kol::KolProfilesController < Api::V1::Kol::BaseController
  def index
    render json: KolByProfileDetailSerializer.new(current_user.profile), status: 200
  end

  def create
    @kol_profile = KolProfile.new(kol_profile_params)
    current_user.delete_roles
    current_user.add_role(:kol_profile)
    if @kol_profile.save
      render json: KolProfileSerializer.new(@kol_profile), status: 201
    else
      render json: @kol_profile.errors.full_messages, status: 422
    end
  end

  def change
    @kol_profile = current_user.profile.kol_profile
    if @kol_profile.update(kol_profile_params)
      render json: KolProfileSerializer.new(@kol_profile), status: 200
    else
      render json: @kol_profile.errors.full_messages, status: 422
    end
  end

  private

  def kol_profile_params
    params.require(:kol_profile).permit(:tiktok_path, :youtube_path, :facebook_path, :instagram_path, :about_me)
  end
end
