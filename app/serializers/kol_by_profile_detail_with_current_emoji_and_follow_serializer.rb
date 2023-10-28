class KolByProfileDetailWithCurrentEmojiAndFollowSerializer < KolByProfileDetailWithCurrentUserEmojiSerializer
  attribute :current_user_follow do |profile, params|
    profile.followed.find_by(follower_id: params[:profile_id])
  end
end
