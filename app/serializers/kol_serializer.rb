class KolSerializer < BaseSerializer
  attributes :id, :tiktok_path, :youtube_path, :facebook_path, :instagram_path, :about_me

  attribute :industry do |kol|
    IndustryWithoutDescriptionSerializer.new(
      kol.industry_associations.map(&:industry)
    )
  end
end
