class BussinessByProfileDetailSerializer < BussinessByProfileSerializer
  attribute :job_num do |profile|
    profile.jobs.where(status: 'post').count
  end

  attribute :review_num do |profile|
    profile.reviewed.count
  end

  attribute :follow do |profile|
    profile.followed.count
  end
end
