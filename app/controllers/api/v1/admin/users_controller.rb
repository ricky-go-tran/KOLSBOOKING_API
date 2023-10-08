class Api::V1::Admin::UsersController < Api::V1::Admin::BaseController
  before_action :prepare_user, only: %i[show lock unlock]

  def index
    users = if params[:tab].blank? || params[:tab] == 'all'
              User.all.includes(:profile).order(created_at: :desc)
            else
              User.joins(:profile).where("profiles.status = '#{params[:tab]}'").order(created_at: :desc)
            end
    pagy, users = pagy(users, page: page_number, items: page_size)
    render json: UserSerializer.new(users, { meta: pagy_metadata(pagy) }), status: 200
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

  def show
    render json: UserSerializer.new(@user)
  end

  def unlock
    if @user.profile.status == 'valid'
      render json: { errors: [I18n.t('user.error_already_valid')] }, status: 422
    elsif @user.profile.update(status: 'valid')
      SendMailUnlockUserWorker.perform_sync(@user.id)
      render json: UserSerializer.new(@user), status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  def lock
    if @user.profile.status == 'lock'
      render json: { errors: [I18n.t('user.error_already_lock')] }, status: 422
    elsif @user.profile.update(status: 'lock')
      SendMailLockUserWorker.perform_in(30.seconds, @user.id)
      render json: UserSerializer.new(@user), status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, profile_attributes: [:fullname, :birthday, :phone, :address, :status, :avatar, :user_id])
  end

  def prepare_user
    @user = User.find_by(id: params[:id])
  end
end
