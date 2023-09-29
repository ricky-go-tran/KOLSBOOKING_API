class Kol::JobPolicy < ApplicationPolicy
  def show?
    user.profile.id == record.kol_id
  end

  def apply?
    user.profile.id == record.kol_id
  end

  def complete?
    user.profile.id == record.kol_id
  end

  def payment?
    user.profile.id == record.kol_id
  end

  def finish?
    user.profile.id == record.kol_id
  end

  def cancle?
    user.profile.id == record.kol_id
  end

  class Scope < Scope
    def resolve
      scope.where(kol_id: user.profile.id)
    end
  end
end
