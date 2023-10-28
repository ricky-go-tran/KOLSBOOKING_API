# == Schema Information
#
# Table name: notifications
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  description :text             not null
#  type_notice :string           default("notification"), not null
#  is_read     :boolean          default(FALSE), not null
#  sender_id   :bigint           not null
#  receiver_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
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
