class KolSerializer < BaseKolSerializer
  attribute :industry do |kol|
    IndustryWithoutDescriptionSerializer.new(
      kol.industry_associations.includes(:industry).map(&:industry)
    )
  end
end
