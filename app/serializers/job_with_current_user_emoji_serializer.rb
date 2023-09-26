class JobWithCurrentUserEmojiSerializer < BaseSerializer
  attributes :id, :title, :description, :requirement, :price, :created_at, :status

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

  attribute :current_user_like do |job, params|
    job.emojis.find_by(status: 'like', profile_id: params[:profile_id])
  end

  attribute :current_user_unlike do |job, params|
    job.emojis.find_by(status: 'unlike', profile_id: params[:profile_id])
  end
end
