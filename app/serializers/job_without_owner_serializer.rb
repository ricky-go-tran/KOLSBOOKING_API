class JobWithoutOwnerSerializer < BaseSerializer
  attributes :id, :title, :description
  attribute :industry do |job|
    IndustryWithoutDescriptionSerializer.new(
      job.industry_associations.includes(:industry).map(&:industry)
    )
  end

  attribute :image do |job|
    if job.image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(job.image, only_path: true)
    else
      'null'
    end
  end
end
