class ProfileKolPolicy < ApplicationPolicy
  def show?
    record.status == 'valid' && record.has_role?(:kol)
  end

  class Scope < Scope
    # def resolve
    #   record.all
    # end
  end
end
