require 'rails_helper'
require 'pry-rails'

RSpec.describe 'Api::V1::Kol::Task', type: :request do
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
        get api_v1_kol_tasks_path
        expect(response).to have_http_status(200)
      end

      it 'return array' do
        sign_in @user
        get api_v1_kol_tasks_path
        response_data = JSON.parse(response.body)
        expect(response_data).to have_key('data')
        expect(response_data['data']).to be_an(Array)
      end
    end

    describe 'GET /show' do
      it 'return http success' do
        sign_in @user
        @task = create(:task, kol_profile: @kol_profile)
        get api_v1_kol_task_path(@task.id)
        expect(response).to have_http_status(200)
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
        get api_v1_kol_tasks_path
        expect(response).to have_http_status(401)
      end
    end

    describe 'GET /show' do
      it 'return http fails' do
        sign_in @user
        @task = create(:task, kol_profile: @kol_profile)

        get api_v1_kol_task_path(@task.id)
        expect(response).to have_http_status(401)
      end
    end
  end
end
