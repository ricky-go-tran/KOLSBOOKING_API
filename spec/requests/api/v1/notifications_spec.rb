require 'rails_helper'
require 'pry-rails'

RSpec.describe 'Api::V1::Notifications', type: :request do
  context 'not login' do
    describe 'GET /index' do
      it 'return http success' do
        get api_v1_notifications_path
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
        get api_v1_notifications_path
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /create' do
      it 'creates a new notification' do
        sign_in @user
        notification_params = {
          notification: {
            title: 'New Notification',
            description: 'This is a test notification',
            type_notice: 'type',
            sender_id: @profile.id,
            receiver_id: @profile.id
          }
        }
        post api_v1_notifications_path, params: notification_params
        expect(response).to have_http_status(201)
        expect(Notification.last.title).to eq('New Notification')
      end

      it 'returns unprocessable entity' do
        sign_in @user

        notification_params = {
          notification: {
            title: '',
            description: 'This is a test notification',
            type_notice: 'type',
            sender_id: @profile.id,
            receiver_id: @profile.id
          }
        }
        post api_v1_notifications_path, params: notification_params
        expect(response).to have_http_status(422)
      end
    end
  end
end
