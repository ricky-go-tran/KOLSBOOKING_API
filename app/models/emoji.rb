class Emoji < ApplicationRecord
  resourcify
  belongs_to :emojiable, polymorphic: true
  belongs_to :profile

  validates :status, presence: true, inclusion: { in: EMOJI_STATUS }
end
