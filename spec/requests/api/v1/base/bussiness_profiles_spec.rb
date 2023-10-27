# spec/requests/api/v1/base/bussiness_profiles_request_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Base::BussinessProfiles', type: :request do
  describe 'GET /api/v1/base/bussiness_profiles' do
    context 'when a user is authenticated' do
      before do
        @user = create(:user)
        @profile = create(:profile, user_id: @user.id)
        @kol_profile = create(:kol_profile, profile_id: @profile.id)
        @user.delete_roles
        @user.add_role :base
        sign_in @user
      end
      it 'returns a successful response' do
        get api_v1_base_bussiness_profiles_path
        expect(response).to have_http_status(200)
      end

      it 'returns JSON data with expected keys' do
        get api_v1_base_bussiness_profiles_path
        expect(JSON.parse(response.body)).to have_key('data')
      end

      it 'returns JSON data with specific keys' do
        get api_v1_base_bussiness_profiles_path
        expect(JSON.parse(response.body)['data']).to have_key('attributes')
        expect(JSON.parse(response.body)['data']['attributes']).to have_key('bussiness')
      end
    end

    context 'when a user is not authenticated' do
      it 'returns an unauthorized response' do
        get api_v1_base_bussiness_profiles_path
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/v1/base/bussiness_profiles' do
    before do
      @user = create(:user)
      @profile = create(:profile, user_id: @user.id)
      @kol_profile = create(:kol_profile, profile_id: @profile.id)
      @user.delete_roles
      @user.add_role :base
      sign_in @user
    end

    context 'with valid parameters' do
      let(:valid_params) { { type_profile: 'bussiness', overview: 'A brief overview of the business.' } }

      it 'creates a bussiness profile' do
        post api_v1_base_bussiness_profiles_path, params: { bussiness_profile: valid_params }
        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { overview: '' } }

      it 'returns an error response' do
        post api_v1_base_bussiness_profiles_path, params: { bussiness_profile: invalid_params }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /api/v1/base/bussiness_profiles/change' do
    context 'when a user is authenticated' do
      before do
        @user = create(:user)
        @profile = create(:profile, user_id: @user.id)
        @bussiness = create(:bussiness, profile_id: @profile.id)
        @user.delete_roles
        @user.add_role :base
        sign_in @user
      end

      context 'with valid parameters' do
        let(:valid_params) { { type_profile: 'bussiness', overview: 'Updated business overview.' } }

        it 'updates the bussiness profile' do
          put '/api/v1/base/bussiness_profiles/change', params: { bussiness_profile: valid_params }
          expect(response).to have_http_status(200)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) { { overview: '' } }

        it 'returns an error response' do
          put '/api/v1/base/bussiness_profiles/change', params: { bussiness_profile: invalid_params }
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'when a user is not authenticated' do
      it 'returns an unauthorized response' do
        put '/api/v1/base/bussiness_profiles/change'
        expect(response).to have_http_status(401)
      end
    end
  end
end
