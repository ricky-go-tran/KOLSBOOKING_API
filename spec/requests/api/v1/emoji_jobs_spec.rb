require 'rails_helper'

RSpec.describe 'Api::V1::EmojiJobs', type: :request do
  context 'not login' do
    describe 'GET /index' do
      it 'return http success' do
        get api_v1_emoji_jobs_path
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
        get api_v1_emoji_jobs_path
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /api/v1/emoji_jobs/like' do
      it 'likes a job' do
        job = create(:job, profile_id: @profile.id)

        post like_api_v1_emoji_job_path(job.id)
        expect(response).to have_http_status(201)
        expect(Emoji.last.status).to eq('like')
      end

      it 'updates a job to "like" if already liked' do
        job = create(:job, profile_id: @profile.id)
        emoji = create(:emoji, profile: @profile, emojiable: job, status: 'unlike')

        post like_api_v1_emoji_job_path(job.id)
        expect(response).to have_http_status(200)
        emoji.reload
        expect(emoji.status).to eq('like')
      end

      it 'returns a message if already liked' do
        job = create(:job, profile_id: @profile.id)
        create(:emoji, profile: @profile, emojiable: job, status: 'like')

        post like_api_v1_emoji_job_path(job.id)
        expect(response).to have_http_status(204)
      end
    end

    describe 'POST /api/v1/emoji_jobs/unlike' do
      it 'unlikes a job' do
        job = create(:job, profile_id: @profile.id)
        post unlike_api_v1_emoji_job_path(job.id)

        expect(response).to have_http_status(201)
        expect(Emoji.last.status).to eq('unlike')
      end

      it 'updates a job to "unlike" if already unliked' do
        job = create(:job, profile_id: @profile.id)
        emoji = create(:emoji, profile: @profile, emojiable: job, status: 'like')

        post unlike_api_v1_emoji_job_path(job.id)
        expect(response).to have_http_status(200)
        emoji.reload
        expect(emoji.status).to eq('unlike')
      end

      it 'returns a message if already unliked' do
        job = create(:job, profile_id: @profile.id)
        create(:emoji, profile: @profile, emojiable: job, status: 'unlike')

        post unlike_api_v1_emoji_job_path(job.id)
        expect(response).to have_http_status(204)
      end
    end
    describe 'DELETE /api/v1/emoji_jobs/:id' do
      it 'deletes an emoji' do
        job = create(:job, profile_id: @profile.id)
        emoji = create(:emoji, profile: @profile, emojiable: job)

        delete api_v1_emoji_job_path(job.id)
        expect(response).to have_http_status(200)
        expect(Emoji.find_by(id: emoji.id)).to be_nil
      end
    end
  end
end
