class Base::InvoicePolicy < ApplicationPolicy
  def show?
    record.profile_id == user.profile.id
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
