class KolPolicy < ApplicationPolicy
  def show?
    record.status == 'valid' && record.user.has_role?(:kol)
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
