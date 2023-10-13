# == Schema Information
#
# Table name: jobs
#
#  id          :bigint           not null, primary key
#  profile_id  :bigint           not null
#  kol_id      :bigint           not null
#  title       :string           not null
#  description :text
#  price       :float            not null
#  status      :string           default("post"), not null
#  stripe_id   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  requirement :text             default("Requirement content"), not null
#
require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:price) }
  end
  describe 'association' do
    it { should belong_to(:profile) }
    it { should have_one_attached(:image) }
    it { should have_many(:bookmarks) }
    it { should have_many(:emojis) }
    it { should have_many(:industry_associations) }
    it { should accept_nested_attributes_for(:industry_associations).allow_destroy(true) }
  end
end
