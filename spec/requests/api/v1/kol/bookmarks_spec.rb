require 'rails_helper'

RSpec.describe 'Api::V1::Kol::Bookmarks', type: :request do
  let(:user) { create(:user) }
  context 'not login' do
    describe 'GET /index' do
      it 'return authorization' do
        get api_v1_kol_bookmarks_path
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'login' do
    before do
      @user = create(:user)
      @profile = create(:profile, user_id: @user.id)
      @kol_profile = create(:kol_profile, profile_id: @profile.id)
      @user.delete_roles
      @user.add_role :kol
    end
    describe 'GET /index' do
      it 'return http success' do
        sign_in @user
        get api_v1_kol_bookmarks_path
        expect(response).to have_http_status(200)
      end

      it 'return array' do
        sign_in @user
        get api_v1_kol_jobs_path
        response_data = JSON.parse(response.body)
        expect(response_data).to have_key('data')
        expect(response_data['data']).to be_an(Array)
      end
    end
  end

  context 'login with other role' do
    before do
      @user = create(:user)
      @profile = create(:profile, user_id: @user.id)
      @kol_profile = create(:kol_profile, profile_id: @profile.id)
      @user.delete_roles
      @user.add_role :base
    end
    describe 'GET /index' do
      it 'return http unaunthorization' do
        sign_in @user
        get api_v1_kol_bookmarks_path
        expect(response).to have_http_status(401)
      end
    end
  end
end
