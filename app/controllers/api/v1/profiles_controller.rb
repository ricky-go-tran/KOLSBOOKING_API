class Api::V1::ProfilesController < ApplicationController
  before_action :check_authentication
  before_action :prepare_profile, only: %i[index change]

  def index
    render json: ProfileSerializer.new(@profile), status: 200
  end

  def create
    profile = Profile.new(profile_params)
    if profile.save
      render json: ProfileSerializer.new(profile), status: 201
    else
      render json: profile.errors.full_messages, status: 422
    end
  end

  def change
    if @profile.update(profile_update_params)
      render json: ProfileSerializer.new(@profile), status: 200
    else
      render json: @profile.errors.full_messages, status: 422
    end
  end

  private

  def prepare_profile
    @profile = Profile.find_by(id: current_user.profile.id)
  end

  def profile_params
    params.require(:profile).permit(:fullname, :birthday, :phone, :address, :avatar, :user_id)
  end

  def profile_update_params
    params.require(:profile).permit(:fullname, :birthday, :phone, :address, :avatar)
  end
end
