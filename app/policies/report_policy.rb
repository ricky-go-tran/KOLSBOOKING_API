class ReportPolicy < ApplicationPolicy
  def update?
    record.profile_id == user.profile.id
  end

  def destroy?
    record.profile_id == user.profile.id
  end

  class Scope < Scope
    def resolve
      scope.where(profile_id: user.profile.id)
    end
  end
end
