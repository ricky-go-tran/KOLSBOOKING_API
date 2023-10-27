# spec/requests/api/v1/kol/statistical_request_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Admin::Dashboard', type: :request do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user:) }

  before do
    @user = create(:user)
    @profile = create(:profile, user_id: @user.id)
    @kol_profile = create(:kol_profile, profile_id: @profile.id)
    @user.delete_roles
    @user.add_role :admin
    sign_in @user
  end

  describe 'GET /api/v1/admin/dashboard' do
    it 'returns a successful response' do
      get '/api/v1//admin/dashboard', params: { tab: 'half_year' }
      expect(response).to have_http_status(200)
    end
  end
end
