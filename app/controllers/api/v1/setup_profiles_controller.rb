class Api::V1::SetupProfilesController < ApplicationController
  before_action :check_authentication
  skip_before_action :check_first_login

  def base
    setup_profile(:base, base_params)
  end

  def kol
    setup_profile(:kol, kol_params)
  end

  private

  def setup_profile(role, params)
    profile = Profile.new(params)
    profile.user_id = current_user.id

    if profile.save
      if role == :kol
        current_user.delete_roles
        current_user.add_role :kol
      end

      render json: ProfileSerializer.new(profile), status: :ok
    else
      render json: { errors: profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def base_params
    params.require(:base).permit(:fullname, :birthday, :phone, :address, :avatar)
  end

  def kol_params
    params.require(:kol).permit(:fullname, :birthday, :phone, :address, :avatar, kol_profile_attributes: [:tiktok_path, :youtube_path, :facebook_path, :instagram_path, :about_me])
  end
end
