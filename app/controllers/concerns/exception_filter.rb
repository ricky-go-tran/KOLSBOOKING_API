require 'English'
module ExceptionFilter
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
  end

  private

  def not_found
    Sentry.capture_exception(StandardError.new($ERROR_INFO.message))
    render json: {
      errors: I18n.t('job.error.not_found')
    }, status: 404
  end

  def user_not_authorized
    render json: {
      errors: I18n.t('user.not_authorized')
    }, status: :forbidden
  end
end
