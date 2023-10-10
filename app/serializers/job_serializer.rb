class JobSerializer < BaseSerializer
  attributes :id, :title, :description, :requirement, :price, :status, :created_at, :stripe_id

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
end
