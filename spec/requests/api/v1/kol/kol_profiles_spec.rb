require 'rails_helper'

RSpec.describe 'Api::V1::Kol::KolProfiles', type: :request do
  describe 'NO LOGIN GET /index' do
    it 'index' do
      get '/api/v1/kol/kol_profiles'
      expect(response).to have_http_status(401)
    end
  end
end
