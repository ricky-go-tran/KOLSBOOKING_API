require 'rails_helper'

RSpec.describe 'Api::V1::EmojiProfiles', type: :request do
  context 'not login' do
    describe 'GET /index' do
      it 'return http success' do
        get api_v1_emoji_profiles_path
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
      sign_in @user
    end

    describe 'GET /index' do
      it 'return http success' do
        get api_v1_emoji_profiles_path
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /api/v1/emoji_profiles/like' do
      it 'likes a profile' do
        post like_api_v1_emoji_profile_path(@profile.id)
        expect(response).to have_http_status(201)
        expect(Emoji.last.status).to eq('like')
      end

      it 'updates a profile to "like" if already liked' do
        emoji = create(:emoji, profile: @profile, emojiable: @profile, emojiable_type: 'Profile', status: 'unlike')

        post like_api_v1_emoji_profile_path(@profile.id)
        expect(response).to have_http_status(200)
        emoji.reload
        expect(emoji.status).to eq('like')
      end

      it 'returns a message if already liked' do
        create(:emoji, profile: @profile, emojiable: @profile, emojiable_type: 'Profile', status: 'like')

        post like_api_v1_emoji_profile_path(@profile.id)
        expect(response).to have_http_status(204)
      end
    end

    describe 'POST /api/v1/emoji_profiles/unlike' do
      it 'unlikes a profile' do
        post unlike_api_v1_emoji_profile_path(@profile.id)
        expect(response).to have_http_status(201)
        expect(Emoji.last.status).to eq('unlike')
      end

      it 'updates a profile to "unlike" if already unliked' do
        emoji = create(:emoji, profile: @profile, emojiable: @profile, emojiable_type: 'Profile', status: 'like')

        post unlike_api_v1_emoji_profile_path(@profile.id)
        expect(response).to have_http_status(200)
        emoji.reload
        expect(emoji.status).to eq('unlike')
      end

      it 'returns a message if already unliked' do
        create(:emoji, profile: @profile, emojiable: @profile, emojiable_type: 'Profile', status: 'unlike')

        post unlike_api_v1_emoji_profile_path(@profile.id)
        expect(response).to have_http_status(204)
      end
    end

    describe 'DELETE /api/v1/emoji_profiles/:id' do
      it 'deletes an emoji' do
        emoji = create(:emoji, profile: @profile, emojiable: @profile, emojiable_type: 'Profile')

        delete api_v1_emoji_profile_path(@profile.id)
        expect(response).to have_http_status(200)
        expect(Emoji.find_by(id: emoji.id)).to be_nil
      end
    end
  end
end
