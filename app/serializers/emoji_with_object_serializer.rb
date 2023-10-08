class EmojiWithObjectSerializer < EmojiSerializer
  attribute :object do |emoji|
    if emoji.emojiable_type == 'Job'
      JobSerializer.new(emoji.emojiable)
    else
      ProfileSerializer.new(emoji.emojiable)
    end
  end
end
