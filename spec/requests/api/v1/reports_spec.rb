require 'rails_helper'
require 'pry-rails'

RSpec.describe 'Api::V1::Reports', type: :request do
  context 'with a logged-in user' do
    before do
      @user = create(:user)
      @profile = create(:profile, user_id: @user.id)
      @kol_profile = create(:kol_profile, profile_id: @profile.id)
      @user.delete_roles
      @user.add_role :kol
    end

    describe 'POST #create' do
      it 'creates a new report' do
        sign_in @user
        job = create(:job, profile: @profile)
        report_params = {
          report: {
            title: 'Test Report',
            description: 'This is a test report',
            reportable_type: 'Job',
            reportable_id: job.id,
            profile_id: @profile.id
          }
        }

        post api_v1_reports_path, params: report_params
        expect(response).to have_http_status(:created)
        expect(Report.last.title).to eq('Test Report')
      end

      it 'returns unprocessable entity for an invalid report' do
        sign_in @user
        job = create(:job, profile: @profile)
        invalid_report_params = {
          report: {
            title: '',
            description: 'This is an invalid report',
            reportable_type: 'Job',
            reportable_id: job.id,
            profile_id: @profile_id
          }
        }
        post api_v1_reports_path, params: invalid_report_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
