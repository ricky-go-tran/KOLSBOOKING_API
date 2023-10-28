class Api::V1::Kol::BaseController < ApplicationController
  before_action :check_authentication
  before_action :check_kol

  private

  def check_kol
    unless current_user.has_role?(:kol)
      render json: {
        status: 401,
        message: I18n.t('user.not_enough_authorization')
      }, status: :unauthorized
    end
  end
end
