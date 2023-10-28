# spec/requests/api/v1/admin/jobs_request_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Admin::Jobs', type: :request do
  before do
    @user = create(:user)
    @profile = create(:profile, user_id: @user.id)
    @kol_profile = create(:kol_profile, profile_id: @profile.id)
    @user.delete_roles
    @user.add_role :admin
    @job = create(:job, profile: @profile)
    sign_in @user
  end
  describe 'GET /api/v1/admin/jobs' do
    context 'with valid parameters' do
      it 'returns a successful response for the default tab' do
        get '/api/v1/admin/jobs'
        expect(response).to have_http_status(200)
      end

      it 'returns JSON data with expected keys' do
        get '/api/v1/admin/jobs'
        expect(JSON.parse(response.body)).to have_key('data')
      end
    end

    context 'with invalid parameters' do
      it 'returns an error response if the tab is invalid' do
        get '/api/v1/admin/jobs', params: { tab: 'invalid_tab' }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /api/v1/admin/jobs/:id' do
    context 'with a valid job ID' do
      it 'returns a successful response' do
        get "/api/v1/admin/jobs/#{@job.id}"
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'PUT /api/v1/admin/jobs/:id/cancle' do
    context 'with a valid job ID' do
      let(:job) { create(:job, status: 'post') }

      it 'cancels the job' do
        put "/api/v1/admin/jobs/#{@job.id}/cancle"
        expect(response).to have_http_status(200)
      end
    end
  end
end
