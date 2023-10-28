# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  fullname   :string           not null
#  birthday   :date
#  phone      :string
#  address    :text
#  status     :string           default("valid")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  avatar_url :string
#  uid        :string
#  provider   :string
#  stripe_id  :string           default("none"), not null
#
require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'validations' do
    before do
      Profile.skip_callback(:validation, :before, :create_on_stripe, if: -> { true })
    end

    it { should validate_presence_of(:fullname) }
    it { should validate_presence_of(:birthday) }
    # it { should validate_length_of(:fullname).is_at_least(4) }
    # it { should validate_length_of(:fullname).is_at_most(20) }
    # it { should validate_length_of(:address).is_at_least(5) }
    # it { should validate_length_of(:address).is_at_most(200) }
    # it { should validate_length_of(:phone).is_equal_to(10) }
    # it { should validate_length_of(:phone).is_equal_to(10).on(:create) }
  end

  describe 'association' do
    it { should belong_to(:user) }
    it { should have_one(:kol_profile) }
    it { should have_many(:emojis) }
    it { should have_many(:reports) }
    it { should have_many(:jobs) }
    it { should have_many(:follower).class_name('Follower').with_foreign_key('follower_id') }
    it { should have_many(:followed).class_name('Follower').with_foreign_key('followed_id') }
    it { should have_many(:sender).class_name('Notification').with_foreign_key('sender_id') }
    it { should have_many(:receiver).class_name('Notification').with_foreign_key('receiver_id') }
  end
end
