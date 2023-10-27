require 'rails_helper'
require 'pry-rails'

RSpec.describe 'Api::V1::Notifications', type: :request do
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
        get reviews_by_reviewed_api_v1_review_path(@profile.id)
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /create' do
      it 'creates a new review' do
        review_params = {
          review: {
            content: 'This is a review',
            reviewer_id: @profile.id,
            reviewed_id: @profile.id
          }
        }

        sign_in @user
        post api_v1_reviews_path, params: review_params

        expect(response).to have_http_status(201)
        expect(Review.last.content).to eq('This is a review')
      end

      it 'returns unprocessable entity for an invalid review' do
        review_params = {
          review: {
            content: '',
            reviewer_id: 0,
            reviewed_id: @profile.id
          }
        }

        sign_in @user
        post api_v1_reviews_path, params: review_params

        expect(response).to have_http_status(422)
      end
    end
  end
end
