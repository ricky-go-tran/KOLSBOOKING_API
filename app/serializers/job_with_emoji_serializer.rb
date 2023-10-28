class JobWithEmojiSerializer < JobSerializer
  attribute :like_num do |job|
    job.emojis.where(status: 'like').count
  end

  attribute :unlike_num do |job|
    job.emojis.where(status: 'unlike').count
  end

  attribute :industry do |job|
    IndustryWithoutDescriptionSerializer.new(
      job.industry_associations.includes(:industry).map(&:industry)
    )
  end
end
