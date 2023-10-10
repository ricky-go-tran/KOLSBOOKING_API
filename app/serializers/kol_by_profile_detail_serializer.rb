class KolByProfileDetailSerializer < KolByProfileSerializer
  attribute :job_complete_num do |profile|
    Job.where(kol_id: profile.id, status: ['complete', 'finish', 'payment']).count
  end
end
