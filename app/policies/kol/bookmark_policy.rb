class Kol::BookmarkPolicy < ApplicationPolicy
  def unmark?
    user.profile.kol_profile.id == record.kol_profile_id
  end

  def mark?
    user.profile.kol_profile.id == record.kol_profile_id
  end

  class Scope < Scope
    def resolve
      scope.where(kol_profile_id: user.profile.kol_profile)
    end
  end
end
