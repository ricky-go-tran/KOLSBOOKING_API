require 'rails_helper'

RSpec.describe 'Api::V1::Kol::Jobs', type: :request do
  let(:user) { create(:user) }
  context 'not login' do
    describe 'GET /index' do
      it 'return authorization' do
        get api_v1_kol_jobs_path
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
        get api_v1_kol_jobs_path
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

    describe 'GET /show' do
      it 'return http success' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id)
        get api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(200)
      end
    end

    describe 'PUT /apply' do
      it 'return success' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'booking')
        put apply_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(200)
      end

      it 'return fails' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'payment')
        put apply_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(422)
      end
    end

    describe 'PUT /complete' do
      it 'return success' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'apply')
        put complete_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(200)
      end

      it 'return fails' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'payment')
        put complete_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(422)
      end
    end

    describe 'PUT /payment' do
      it 'return success' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'complete')
        put payment_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(200)
      end

      it 'return fails' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'booking')
        put payment_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(422)
      end
    end

    describe 'PUT /finish' do
      it 'return success' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'payment')
        put finish_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(200)
      end

      it 'return fails' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'booking')
        put finish_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(422)
      end
    end

    describe 'PUT /cancel' do
      it 'return success' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'post')
        put cancle_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(200)
      end

      it 'return fails' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'finish')
        put cancle_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(422)
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
        get api_v1_kol_jobs_path
        expect(response).to have_http_status(401)
      end
    end

    describe 'GET /show' do
      it 'return authorization' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id)
        get api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(401)
      end
    end

    describe 'PUT /apply' do
      it 'return authorization' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'booking')
        put apply_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(401)
      end

      it 'return fails' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'payment')
        put apply_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(401)
      end
    end

    describe 'PUT /complete' do
      it 'return authorization' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'apply')
        put complete_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(401)
      end

      it 'return authorization' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'payment')
        put complete_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(401)
      end
    end

    describe 'PUT /payment' do
      it 'return authorization' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'complete')
        put payment_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(401)
      end

      it 'return fails' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'booking')
        put payment_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(401)
      end
    end

    describe 'PUT /finish' do
      it 'return authorization' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'payment')
        put finish_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(401)
      end

      it 'return fails' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'booking')
        put finish_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(401)
      end
    end

    describe 'PUT /cancel' do
      it 'return authorization' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'post')
        put cancle_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(401)
      end

      it 'return fails' do
        sign_in @user
        @job = create(:job, profile: @profile, kol_id: @profile.id, status: 'finish')
        put cancle_api_v1_kol_job_path(@job.id)
        expect(response).to have_http_status(401)
      end
    end
  end
end
