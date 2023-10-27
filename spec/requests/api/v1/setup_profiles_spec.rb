# Trong tệp spec/controllers/api/v1/setup_profiles_controller_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::SetupProfiles', type: :request do
  before do
    @user = create(:user)
    @user.delete_roles
    @user.add_role :base
  end

  describe 'POST #base' do
    it 'creates a base profile for the user' do
      base_profile_params = {
        base: {
          fullname: 'John Doe',
          birthday: '1990-01-01',
          phone: '1234567890',
          address: '123 Main St'
        }
      }
      sign_in @user
      post base_api_v1_setup_profiles_path, params: base_profile_params
      expect(response).to have_http_status(200)
      expect(Profile.last.fullname).to eq('John Doe')
    end

    it 'returns unprocessable entity for an invalid base profile' do
      invalid_base_profile_params = {
        base: {
          fullname: '',
          birthday: '1990-01-01',
          phone: '1234567890',
          address: '123 Main St'
        }
      }
      sign_in @user
      post base_api_v1_setup_profiles_path, params: invalid_base_profile_params
      expect(response).to have_http_status(422)
    end
  end

  describe 'POST #kol' do
    it 'creates a kol profile for the user and assigns the role :kol' do
      kol_profile_params = {
        kol: {
          fullname: 'KOL User',
          birthday: '1985-02-02',
          phone: '9876543210',
          address: '456 Secondary St',
          kol_profile_attributes: {
            tiktok_path: 'tiktok_user',
            youtube_path: 'youtube_user',
            facebook_path: 'facebook_user',
            instagram_path: 'instagram_user',
            about_me: 'About me text'
          }
        }
      }
      sign_in @user
      post kol_api_v1_setup_profiles_path, params: kol_profile_params
      expect(response).to have_http_status(200)
      expect(Profile.last.fullname).to eq('KOL User')
      expect(@user.has_role?(:kol)).to be_truthy
    end

    it 'returns unprocessable entity for an invalid kol profile' do
      invalid_kol_profile_params = {
        kol: {
          fullname: '',
          birthday: '1985-02-02',
          phone: '9876543210',
          address: '456 Secondary St',
          kol_profile_attributes: {
            tiktok_path: 'tiktok_user',
            youtube_path: 'youtube_user',
            facebook_path: 'facebook_user',
            instagram_path: 'instagram_user',
            about_me: 'About me text'
          }
        }
      }
      sign_in @user
      post kol_api_v1_setup_profiles_path, params: invalid_kol_profile_params
      expect(response).to have_http_status(422)
      expect(@user.has_role?(:kol)).to be_falsey
    end
  end
end
