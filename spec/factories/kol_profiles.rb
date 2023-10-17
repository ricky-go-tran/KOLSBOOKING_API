# == Schema Information
#
# Table name: kol_profiles
#
#  id                 :bigint           not null, primary key
#  tiktok_path        :string
#  youtube_path       :string
#  facebook_path      :string
#  instagram_path     :string
#  stripe_public_key  :string
#  stripe_private_key :string
#  profile_id         :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  about_me           :text             default("About me default"), not null
#
FactoryBot.define do
  factory :kol_profile do
    tiktok_path { Faker::Lorem.sentence }
    youtube_path { Faker::Lorem.sentence }
    facebook_path { Faker::Lorem.sentence }
    instagram_path { Faker::Lorem.sentence }
    about_me { Faker::Lorem.sentence }
    stripe_public_key { 'MyString' }
    stripe_private_key { 'MyString' }
  end
end
