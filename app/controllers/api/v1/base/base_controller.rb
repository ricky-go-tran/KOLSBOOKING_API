class Api::V1::Base::BaseController < ApplicationController
  before_action :check_authentication
  before_action :check_base

  private

  def check_base
    unless current_user.has_role?(:base)

      render json: {
        status: 401,
        message: I18n.t('user.not_enough_authorization')
      }, status: :unauthorized
    end
  end
end
