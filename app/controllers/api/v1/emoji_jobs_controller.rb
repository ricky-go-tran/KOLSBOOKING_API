class Api::V1::EmojiJobsController < ApplicationController
  include EmojiHandling

  private

  def emojiable_type
    'Job'
  end
end
