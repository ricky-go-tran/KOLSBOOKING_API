class JobPolicy < ApplicationPolicy
  def show?
    record.status == 'post'
  end

  class Scope < Scope
    def resolve
      scope.where(status: 'post')
    end
  end
end
