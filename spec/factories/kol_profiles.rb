FactoryBot.define do
  factory :kol_profile do
    tiktok_path { "MyString" }
    youtube_path { "MyString" }
    facebook_path { "MyString" }
    instagram_path { "MyString" }
    stripe_public_key { "MyString" }
    stripe_private_key { "MyString" }
    profile { nil }
  end
end
