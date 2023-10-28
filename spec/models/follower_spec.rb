# == Schema Information
#
# Table name: followers
#
#  id          :bigint           not null, primary key
#  follower_id :bigint           not null
#  followed_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Follower, type: :model do
  describe 'association' do
    it { should belong_to(:follower).class_name('Profile') }
    it { should belong_to(:followed).class_name('Profile') }
  end
end
