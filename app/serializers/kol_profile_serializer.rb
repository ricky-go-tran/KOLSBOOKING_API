class KolProfileSerializer < BaseSerializer
  attributes :id, :tiktok_path, :youtube_path, :facebook_path, :instagram_path

  attribute :profile do |kol_profile|
    ProfileSerializer.new(kol_profile.profile)
  end
end
