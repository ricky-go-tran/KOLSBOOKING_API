# spec/requests/api/v1/kol/statistical_request_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Kol::Statistical', type: :request do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user:) }

  before do
    @user = create(:user)
    @profile = create(:profile, user_id: @user.id)
    @kol_profile = create(:kol_profile, profile_id: @profile.id)
    @user.delete_roles
    @user.add_role :kol
    sign_in @user
  end

  describe 'GET /api/v1/kol/statistical' do
    it 'returns a successful response' do
      get '/api/v1/kol/statistical', params: { tab: 'half_year' }
      expect(response).to have_http_status(200)
    end

    it 'returns JSON data with expected keys' do
      get '/api/v1/kol/statistical', params: { tab: 'half_year' }
      expect(JSON.parse(response.body)).to have_key('label')
      expect(JSON.parse(response.body)).to have_key('total_job')
      expect(JSON.parse(response.body)).to have_key('cancle_job')
      expect(JSON.parse(response.body)).to have_key('finish_job')
    end

    it 'returns data with default values' do
      get '/api/v1/kol/statistical', params: { tab: 'half_year' }
      response_data = JSON.parse(response.body)
      expect(response_data['total_job']).to all(be_zero)
      expect(response_data['cancle_job']).to all(be_zero)
      expect(response_data['finish_job']).to all(be_zero)
    end
  end
end
