class Base::JobPolicy < ApplicationPolicy
  def update?
    user.profile.id == record.profile_id
  end

  def cancle?
    user.profile.id == record.profile_id
  end

  def show?
    user.profile.id == record.profile_id
  end

  class Scope < Scope
    def resolve
      scope.where(profile_id: user.profile.id)
    end
  end
end
