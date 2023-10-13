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
FactoryBot.define do
  factory :notification do
  end
end
