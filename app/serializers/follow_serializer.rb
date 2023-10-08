class FollowSerializer < BaseSerializer
  attributes :id, :created_at

  attribute :follower do |follow|
    ProfileSerializer.new(follow.follower)
  end

  attribute :followed do |follow|
    ProfileSerializer.new(follow.followed)
  end
end
