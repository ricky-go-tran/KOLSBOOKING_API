class Api::V1::SetupProfilesController < ApplicationController
  before_action :check_authentication
  skip_before_action :check_first_login

  def base
    base_profile = Profile.new(base_params)
    base_profile.user_id = current_user.id
    if base_profile.save
      render json: ProfileSerializer.new(base_profile), status: 200
    else
      render json: { errors: base_profile.errors.full_messages }, status: 422
    end
  end

  def kol
    kol_profile = Profile.new(kol_params)
    kol_profile.user_id = current_user.id
    if kol_profile.save
      current_user.delete_roles
      current_user.add_role :kol
      render json: ProfileSerializer.new(kol_profile), status: 200
    else
      render json: { errors: kol_profile.errors.full_messages }, status: 422
    end
  end

  private

  def base_params
    params.require(:base).permit(:fullname, :birthday, :phone, :address, :avatar)
  end

  def kol_params
    params.require(:kol).permit(:fullname, :birthday, :phone, :address, :avatar, kol_profile_attributes: [:tiktok_path, :youtube_path, :facebook_path, :instagram_path, :about_me])
  end
end
