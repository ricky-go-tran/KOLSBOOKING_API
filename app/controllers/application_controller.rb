class ApplicationController < ActionController::API
  include Pagy::Backend
  include Pundit::Authorization
  include ExceptionFilter

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_first_login, unless: :devise_controller?

  def page_number
    params.dig(:page, :number) || 1
  end

  def page_size
    params.dig(:page, :size) || Pagy::DEFAULT[:items]
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[email password jti]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  def check_authentication
    if current_user.blank?
      render json: {
        errors: [I18n.t('user.not_login')]
      }, status: 401
    end
  end

  def is_first_login?
    user_signed_in? && current_user.profile.nil?
  end

  def check_first_login
    if is_first_login?
      render json: {
        status: 301,
        message: I18n.t('profile.error.profile_setup')
      }, status: 301
    end
  end

  def check_present_record(record)
    if record.nil?
      render json: { errors: ['Not found item'] }, status: 404
      false
    end
  end
end
