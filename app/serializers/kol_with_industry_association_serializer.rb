class KolWithIndustryAssociationSerializer < BaseKolSerializer
  attribute :industry_associations do |kol|
    IndustryAssociationSerializer.new(kol.industry_associations)
  end
end
