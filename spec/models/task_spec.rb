# == Schema Information
#
# Table name: tasks
#
#  id             :bigint           not null, primary key
#  kol_profile_id :bigint           not null
#  title          :string           not null
#  start_time     :datetime         not null
#  end_time       :datetime         not null
#  status         :string           default("planning"), not null
#  description    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category       :string           default("personal"), not null
#
require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:status) }
  end
  describe 'association' do
    it { should belong_to(:kol_profile) }
  end
end
