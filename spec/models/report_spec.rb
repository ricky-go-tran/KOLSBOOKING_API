# == Schema Information
#
# Table name: reports
#
#  id              :bigint           not null, primary key
#  title           :string           not null
#  description     :text             not null
#  reportable_type :string           not null
#  reportable_id   :bigint           not null
#  profile_id      :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :string           default("pending")
#
require 'rails_helper'

RSpec.describe Report, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end
  describe 'association' do
    it { should belong_to(:profile) }
    it 'is polymorphic' do
      expect(Report.reflect_on_association(:reportable).options[:polymorphic]).to be true
    end
  end
end
