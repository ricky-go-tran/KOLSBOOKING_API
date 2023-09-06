class Emoji < ApplicationRecord
  belongs_to :objective
  belongs_to :profile

  validates :type, presence: true, inclusion: { in: %w[like love unlike haha anrgy] }
end
