class JobWithIndustryAssociationSerializer < BaseSerializer
  attributes :id, :title, :description, :requirement, :price, :created_at, :status

  attribute :image do |job|
    if job.image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(job.image, only_path: true)
    else
      'null'
    end
  end
  attribute :industry_associations do |job|
    IndustryAssociationSerializer.new(job.industry_associations)
  end
end
