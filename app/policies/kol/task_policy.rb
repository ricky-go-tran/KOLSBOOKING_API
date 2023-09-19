class Kol::TaskPolicy < ApplicationPolicy
  def update?
    user.profile.kol_profile.id == record.kol_profile_id
  end

  def destroy?
    user.profile.kol_profile.id == record.kol_profile_id
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(kol_profile_id: user.profile.kol_profile.id)
    end
  end
end
