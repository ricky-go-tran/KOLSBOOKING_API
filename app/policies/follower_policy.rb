class FollowerPolicy < ApplicationPolicy
  def unfollow?
    record.follower_id == user.profile.id
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.includes(:followed, :follower).where(follower_id: user.profile.id)
    end
  end
end
