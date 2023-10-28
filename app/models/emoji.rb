# == Schema Information
#=
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
class Emoji < ApplicationRecord
  EMOJI_STATUS = %w[like unlike].freeze

  resourcify
  belongs_to :emojiable, polymorphic: true
  belongs_to :profile

  validates :status, presence: true, inclusion: { in: EMOJI_STATUS }
end
