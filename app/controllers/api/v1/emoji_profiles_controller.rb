class Api::V1::EmojiProfilesController < ApplicationController
  include EmojiHandling

  private

  def emojiable_type
    'Profile'
  end
end
