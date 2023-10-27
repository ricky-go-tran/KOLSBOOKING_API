class Api::V1::Admin::UsersController < Api::V1::Admin::BaseController
  before_action :prepare_user, only: %i[show lock unlock]

  def index
    users = user_filter(params[:tab])
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
    update_user_status('valid', 'unlock', I18n.t('user.error_already_valid'))
  end

  def lock
    update_user_status('lock', 'lock', I18n.t('user.error_already_lock'))
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, profile_attributes: [:fullname, :birthday, :phone, :address, :status, :avatar, :user_id])
  end

  def prepare_user
    @user = User.find_by(id: params[:id])
  end

  def user_filter(tab)
    if tab.blank? || tab == 'all'
      User.all.includes(:roles, profile: [{ avatar_attachment: :blob }, :google_integrate]).order(created_at: :desc)
    else
      User.includes(:roles, profile: { avatar_attachment: :blob }).where("profiles.status = '#{tab}'").order(created_at: :desc)
    end
  end

  def update_user_status(required_status, new_status, error_message)
    if @user.status == required_status
      render json: { errors: [error_message] }, status: :unprocessable_entity
    elsif @user.update(status: new_status)
      worker = new_status == 'lock' ? SendMailLockUserWorker : SendMailUnlockUserWorker
      worker.perform_in(30.seconds, @user.id, new_status)
      render json: UserSerializer.new(@user), status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
