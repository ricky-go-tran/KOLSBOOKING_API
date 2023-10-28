class ReviewWithReviewerProfileSerializer < BaseSerializer
  attributes :content, :reviewed_id, :created_at

  attribute :reviewer do |review|
    ProfileSerializer.new(review.reviewer)
  end
end
