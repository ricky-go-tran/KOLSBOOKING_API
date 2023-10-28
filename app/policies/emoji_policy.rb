class EmojiPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(profile_id: user.profile.id)
    end
  end
end
