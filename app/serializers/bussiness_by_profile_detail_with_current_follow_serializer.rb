class BussinessByProfileDetailWithCurrentFollowSerializer < BussinessByProfileSerializer
  attribute :job_num do |profile|
    profile.jobs.where(status: 'post').count
  end

  attribute :review_num do |profile|
    profile.reviewed.count
  end

  attribute :follow do |profile|
    profile.followed.count
  end
  attribute :current_user_follow do |profile, params|
    profile.followed.find_by(follower_id: params[:profile_id])
  end
end
