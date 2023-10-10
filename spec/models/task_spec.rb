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
