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
    tiktok_path { 'MyString' }
    youtube_path { 'MyString' }
    facebook_path { 'MyString' }
    instagram_path { 'MyString' }
    stripe_public_key { 'MyString' }
    stripe_private_key { 'MyString' }
    profile { nil }
  end
end
