require 'rails_helper'

RSpec.describe 'Api::V1::Base::invoices', type: :request do
  let(:user) { create(:user) }
  context 'not login' do
    describe 'GET /index' do
      it 'return authorization' do
        get api_v1_admin_users_path
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'login' do
    before do
      @user = create(:user)
      @profile = create(:profile, user_id: @user.id)
      @user.delete_roles
      @user.add_role :admin
    end
    describe 'GET /index' do
      it 'return http success' do
        sign_in @user
        get api_v1_admin_users_path
        expect(response).to have_http_status(200)
      end

      it 'return array' do
        sign_in @user
        get api_v1_admin_users_path
        response_data = JSON.parse(response.body)
        expect(response_data).to have_key('data')
        expect(response_data['data']).to be_an(Array)
      end
    end

    describe 'GET /show' do
      it 'return http success' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id)
        get api_v1_admin_user_path(@job.id)
        expect(response).to have_http_status(200)
      end
    end
  end

  context 'login with other role' do
    before do
      @user = create(:user)
      @profile = create(:profile, user_id: @user.id)
      @user.delete_roles
      @user.add_role :kol
    end
    describe 'GET /index' do
      it 'return http unaunthorization' do
        sign_in @user
        get api_v1_admin_users_path
        expect(response).to have_http_status(401)
      end
    end

    describe 'GET /show' do
      it 'return authorization' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id)
        get api_v1_admin_user_path(@job.id)
        expect(response).to have_http_status(401)
      end
    end
  end
end
