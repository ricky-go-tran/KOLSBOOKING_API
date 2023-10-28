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
class Follower < ApplicationRecord
  belongs_to :follower, class_name: 'Profile'
  belongs_to :followed, class_name: 'Profile'
end
