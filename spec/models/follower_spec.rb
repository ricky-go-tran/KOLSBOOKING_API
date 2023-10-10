require 'rails_helper'

RSpec.describe Follower, type: :model do
  describe 'association' do
    it { should belong_to(:follower).class_name('Profile') }
    it { should belong_to(:followed).class_name('Profile') }
  end
end
