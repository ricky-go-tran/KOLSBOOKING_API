class JobPolicy < ApplicationPolicy
  def show?
    record.status == 'post'
  end

  class Scope < Scope
    def resolve
      scope.includes(:industry_associations, :emojis, :profile).where(status: 'post')
    end
  end
end
