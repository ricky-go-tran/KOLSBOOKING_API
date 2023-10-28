class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include RackSessionFix

  # def google_oauth2
  #   @profile = JWT.decode(params[:credential], nil, false)
  #   @user = User.from_omniauth_google(@profile[0])
  #   if @user.persisted?
  #     sign_in(@user)
  #     render json: UserSerializer.new(@user), status: 200
  #   else
  #     render json: @user.errors.full_messages, status: :unprocessable_entity
  #   end
  # end
end
