require 'rails_helper'

RSpec.describe 'Api::V1::Profiles', type: :request do
  before do
    @user = create(:user)
    @profile = create(:profile, user_id: @user.id)
    @user.delete_roles
    @user.add_role :base
  end

  describe 'GET /api/v1/profiles' do
    it 'returns the user profile' do
      sign_in @user
      get api_v1_profiles_path
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['data']['attributes']['fullname']).to eq(@user.profile.fullname)
    end
  end

  describe 'POST /api/v1/profiles' do
    it 'creates a new profile for the user' do
      sign_in @user
      profile_params = {
        profile: {
          fullname: 'John Doe',
          birthday: '1990-01-01',
          phone: '1234567890',
          address: '123 Main St',
          user_id: @user.id
        }
      }

      post api_v1_profiles_path, params: profile_params
      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)['data']['attributes']['fullname']).to eq('John Doe')
    end
  end

  describe 'PATCH /api/v1/profiles' do
    it 'updates the user profile' do
      sign_in @user
      updated_profile_params = {
        profile: {
          fullname: 'Updated Name',
          birthday: '1995-02-02',
          phone: '9876543210',
          address: '456 Secondary St'
        }
      }

      put change_api_v1_profiles_path, params: updated_profile_params
      expect(response).to have_http_status(200)
      @user.profile.reload
      expect(@user.profile.fullname).to eq('Updated Name')
    end
  end
end
