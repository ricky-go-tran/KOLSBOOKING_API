# == Schema Information
#
# Table name: emojis
#
#  id             :bigint           not null, primary key
#  status         :string           not null
#  emojiable_type :string           not null
#  emojiable_id   :bigint           not null
#  profile_id     :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class EmojiSerializer < BaseSerializer
  attributes :id, :status
end
