require 'rails_helper'

RSpec.describe 'Api::V1::Kols', type: :request do
  describe 'GET /index' do
    it 'index' do
      get api_v1_kols_path, params: { follow: { min: 0, max: 0 }, like: { min: 0, max: 0 } }
      expect(response).to have_http_status(200)
    end

    it 'returns array' do
      get api_v1_kols_path, params: { follow: { min: 0, max: 0 }, like: { min: 0, max: 0 } }
      response_data = JSON.parse(response.body)
      expect(response_data).to have_key('data')
      expect(response_data['data']).to be_an(Array)
    end
  end

  describe 'GET /api/v1/kols/:id' do
    let(:user) { create(:user) }
    let(:profile) { create(:profile, user_id: user.id) }
    let(:kol) { create(:kol_profile, profile_id: profile.id) }
    before do
      user.status = 'valid'
      user.delete_roles
      user.add_role :kol
    end
    context 'when accessing a specific KOL' do
      it 'returns a successful response' do
        get "/api/v1/kols/#{kol.profile.id}"
        expect(response).to have_http_status(200)
      end

      it 'returns JSON data with expected keys' do
        get "/api/v1/kols/#{kol.profile.id}"
        expect(JSON.parse(response.body)).to have_key('data')
      end
    end
  end
end
