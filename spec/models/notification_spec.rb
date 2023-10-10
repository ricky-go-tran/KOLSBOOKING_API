require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end
  describe 'association' do
    it { should belong_to(:sender).class_name('Profile') }
    it { should belong_to(:receiver).class_name('Profile') }
  end
end
