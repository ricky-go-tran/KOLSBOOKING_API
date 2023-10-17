require 'rails_helper'

RSpec.describe 'Api::V1::Kol::Jobs', type: :request do
  describe 'NO LOGIN GET /index' do
    it 'index' do
      get '/api/v1/kol/jobs'
      expect(response).to have_http_status(401)
    end
  end
end
