class KolByProfileDetailWithCurrentUserEmojiSerializer < KolByProfileDetailSerializer
  attribute :current_user_like do |profile, params|
    profile.emojied.find_by(status: 'like', profile_id: params[:profile_id])
  end
  attribute :current_user_unlike do |profile, params|
    profile.emojied.find_by(status: 'unlike', profile_id: params[:profile_id])
  end
end
