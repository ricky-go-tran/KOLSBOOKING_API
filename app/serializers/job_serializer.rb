class JobSerializer < BaseSerializer
  attributes :id, :title, :description, :price, :status, :created_at

  attribute :owner do |job|
    ProfileSerializer.new(job.profile).as_json
  end

  attribute :kol do |job|
    return nil if job.kol_id.blank?

    ProfileSerializer.new(Profile.find_by(id: job.kol_id)).as_json
  end

  attribute :image do |job|
    if job.image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(job.image, only_path: true)
    else
      'null'
    end
  end
end
