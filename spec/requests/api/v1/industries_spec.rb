require 'rails_helper'

RSpec.describe 'Api::V1::Industries', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get api_v1_industries_path
      expect(response).to have_http_status(200)
    end

    it 'returns array' do
      get api_v1_industries_path
      response_data = JSON.parse(response.body)
      expect(response_data).to have_key('data')
      expect(response_data['data']).to be_an(Array)
    end
  end
end
