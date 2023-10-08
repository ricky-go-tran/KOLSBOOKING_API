class KolProfileSerializer < BaseKolSerializer
  attribute :profile do |kol_profile|
    ProfileSerializer.new(kol_profile.profile)
  end
end
