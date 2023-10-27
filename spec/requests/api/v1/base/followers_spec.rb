# spec/requests/api/v1/base/followers_request_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Base::Followers', type: :request do
  before do
    @user = create(:user)
    @profile = create(:profile, user_id: @user.id)
    @kol_profile = create(:kol_profile, profile_id: @profile.id)
    @user.delete_roles
    @user.add_role :base
    sign_in @user
  end
  describe 'GET /api/v1/base/followers' do
    it 'returns a successful response' do
      get '/api/v1/base/followers'
      expect(response).to have_http_status(200)
    end

    it 'returns JSON data with expected keys' do
      get '/api/v1/base/followers'
      expect(JSON.parse(response.body)).to have_key('meta')
      expect(JSON.parse(response.body)).to have_key('data')
    end

    it 'returns a list of followers' do
      create(:follower, follower_id: @profile.id, followed_id: @profile.id)
      create(:follower, follower_id: @profile.id, followed_id: @profile.id)

      get '/api/v1/base/followers'
      expect(response).to have_http_status(200)
      response_data = JSON.parse(response.body)
      expect(response_data['data']).to be_an(Array)
      expect(response_data['data'].size).to eq(2)
    end
  end

  describe 'POST /api/v1/base/followers/follow' do
    it 'creates a new follower' do
      post '/api/v1/base/followers/follow', params: { follower: { follower_id: @profile.id, followed_id: @profile.id } }
      expect(response).to have_http_status(201)
    end
  end
end
