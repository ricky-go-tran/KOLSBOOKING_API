# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionFix

  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        message: 'Logged in successfully.',
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }
    }, status: 200
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.jwt_key!).first
      current_user = User.find_by(id: jwt_payload['sub'])
    end

    if current_user
      render json: {
        errors: ['Logged out successfully.']
      }, status: 200
    else
      render json: {
        errors: ["Couldn't find an active session."]
      }, status: 401
    end
  end
end
