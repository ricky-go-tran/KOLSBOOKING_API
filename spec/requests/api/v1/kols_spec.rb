require 'rails_helper'

RSpec.describe 'Api::V1::Kols', type: :request do
  describe 'GET /index' do
    it 'index' do
      get '/api/v1/kols'
      expect(response).to have_http_status(200)
    end
  end
end
