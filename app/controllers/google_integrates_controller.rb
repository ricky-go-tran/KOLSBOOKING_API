require 'google/api_client/client_secrets'
require 'google/apis/oauth2_v2'

class GoogleIntegratesController < ApplicationController
  def create
    client_secrets_path = File.join(Rails.root, 'config', 'client_secret_google.json')
    client_secrets = Google::APIClient::ClientSecrets.load(client_secrets_path)
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      scope: 'https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email',
      redirect_uri: 'https://kolbooking-gui.vercel.app/redirect'
    )
    auth_client.code = google_integrate_params[:code]
    auth_client.fetch_access_token!
    access_token = auth_client.access_token
    refresh_token = auth_client.refresh_token
    service = Google::Apis::Oauth2V2::Oauth2Service.new
    gmail = service.tokeninfo(access_token:).email
    integrate = GoogleIntegrate.new(access_token:, refresh_token:, code_authorization: google_integrate_params[:code], gmail:, profile_id: current_user.profile.id)
    if integrate.save
      render json: { message: 'Success Integrate' }, status: 200
    else
      render json: { errors: integrate.errors.full_messages }, status: 422
    end
  end

  private

  def google_integrate_params
    params.require(:google_auth).permit(:code, :authuser, :scope, :prompt)
  end

  def check_access_token_expired; end

  def exchange_authorization_code
    client_secrets_path = File.join(Rails.root, 'config', 'client_secrets_google.json')
    @client_secrets = Google::APIClient::ClientSecrets.load(client_secrets_path)
  end
end
