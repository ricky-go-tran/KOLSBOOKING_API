class KolByProfileDetailSerializer < KolByProfileSerializer
  attribute :job_complete_num do |profile|
    Job.where(kol_id: profile.id, status: ['complete', 'finish', 'payment']).count
  end

  attribute :intro_video do |profile|
    if profile.kol_profile.intro_video.attached?
      Rails.application.routes.url_helpers.rails_blob_url(profile.kol_profile.intro_video, only_path: true)
    else
      'null'
    end
  end

  attribute :gallaries do |profile|
    images = profile.kol_profile.gallaries.map do |image|
      {
        id: image.id,
        src: Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true),
        width: 1200,
        height: 560
      }
    end
    images
  end
end
