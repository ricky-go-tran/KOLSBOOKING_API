class JobWithIndustryAssociationSerializer < JobSerializer
  attribute :industry_associations do |job|
    IndustryAssociationSerializer.new(job.industry_associations)
  end
end
