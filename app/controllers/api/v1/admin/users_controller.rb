class Api::V1::Admin::UsersController < Api::V1::Admin::BaseController
  before_action :prepare_user, only: %i[update lock unlock]

  def index
    users = User.all.preload(:profile)
    render json: UserSerializer.new(users), status: 200
  end

  def create
    @user = User.new(user_params)
    @user.add_role :admin
    if @user.save
      render json: UserSerializer.new(@user), status: 201
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  def unlock
    if @user.profile.status == 'invalid'
      render json: { errors: ['This user is already invalid'] }, status: 422
    elsif @user.profile.update(status: 'valid')
      render json: UserSerializer.new(@user), status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  def lock
    if @user.profile.status == 'lock'
      render json: { errors: ['This user is already locked'] }, status: 422
    elsif @user.profile.update(status: 'lock')
      render json: UserSerializer.new(@user), status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 42
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, profile_attributes: [:fullname, :birthday, :phone, :address, :status, :avatar, :user_id])
  end

  def prepare_user
    @user = User.find_by(params[:id])
  end
end
