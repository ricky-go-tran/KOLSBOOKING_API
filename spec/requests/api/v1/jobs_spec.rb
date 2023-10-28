require 'rails_helper'

RSpec.describe 'Api::V1::Jobs', type: :request do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user:) }
  let(:kol_profile) { create(:kol_profile, profile:) }
  let(:job) { create(:job, profile:) }

  describe 'GET /index' do
    it 'returns http success' do
      get api_v1_jobs_path
      expect(response).to have_http_status(200)
    end
    it 'returns array' do
      get api_v1_jobs_path
      response_data = JSON.parse(response.body)
      expect(response_data).to have_key('data')
      expect(response_data['data']).to be_an(Array)
    end
  end
  describe 'GET /api/v1/jobs/:id' do
    it 'returns a job' do
      get api_v1_job_path(job.id)
      expect(response).to have_http_status(200)
    end
    it 'return current user like' do
      sign_in user
      get api_v1_job_path(job.id)
      expect(JSON.parse(response.body)).to have_key('data')
      expect(JSON.parse(response.body)['data']).to have_key('attributes')
      expect(JSON.parse(response.body)['data']['attributes']).to have_key('current_user_like')
    end
  end
end
