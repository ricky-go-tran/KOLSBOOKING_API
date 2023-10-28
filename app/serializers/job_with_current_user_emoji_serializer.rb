class JobWithCurrentUserEmojiSerializer < JobWithEmojiSerializer
  attribute :current_user_like do |job, params|
    job.emojis.find_by(status: 'like', profile_id: params[:profile_id])
  end

  attribute :current_user_unlike do |job, params|
    job.emojis.find_by(status: 'unlike', profile_id: params[:profile_id])
  end
end
