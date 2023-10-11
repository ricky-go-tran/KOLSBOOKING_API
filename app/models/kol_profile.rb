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
class KolProfile < ApplicationRecord
  belongs_to :profile
  has_many :bookmarks
  has_many :tasks
  has_many :industry_associations, as: :insdustry_associationable
  accepts_nested_attributes_for :industry_associations, allow_destroy: true
end
