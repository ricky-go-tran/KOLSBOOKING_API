class JobWithCurrentUserEmojiAndBookmarkSerializer < JobWithCurrentUserEmojiSerializer
  attribute :current_user_bookmark do |job, params|
    job.bookmarks.find_by(kol_profile_id: params[:kol_id])
  end
end
