class JobWithEmojiSerializer < BaseSerializer
  attributes :id, :title, :description, :created_at

  attribute :owner do |job|
    ProfileSerializer.new(job.profile).as_json
  end
  attribute :image do |job|
    if job.image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(job.image, only_path: true)
    else
      'null'
    end
  end

  attribute :like_num do |job|
    job.emojis.where(status: 'like').count
  end

  attribute :unlike_num do |job|
    job.emojis.where(status: 'unlike').count
  end
end
