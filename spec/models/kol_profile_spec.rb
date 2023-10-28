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
require 'rails_helper'

RSpec.describe KolProfile, type: :model do
  describe 'association' do
    it { should belong_to(:profile) }
    it { should have_many(:bookmarks) }
    it { should have_many(:tasks) }
    it { should have_many(:industry_associations) }
    it { should accept_nested_attributes_for(:industry_associations).allow_destroy(true) }
  end
end
