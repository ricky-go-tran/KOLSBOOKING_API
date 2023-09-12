class Api::V1::Admin::BaseController < ApplicationController
  before_action :check_authentication
  before_action :check_admin

  private

  def check_admin
    unless current_user.has_role?(:admin)
      render json: {
        status: 401,
        message: I18n.t('user.not_enough_authorization')
      }, status: :unauthorized
    end
  end
end
