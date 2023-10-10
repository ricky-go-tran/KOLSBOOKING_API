class Emoji < ApplicationRecord
  EMOJI_STATUS = %w[like unlike].freeze

  resourcify
  belongs_to :emojiable, polymorphic: true
  belongs_to :profile

  validates :status, presence: true, inclusion: { in: EMOJI_STATUS }
end
