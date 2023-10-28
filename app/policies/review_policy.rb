class ReviewPolicy < ApplicationPolicy
  class Scope < Scope
    # def resolve
    #   scope.where(reviewed: user.profile.id)
    # end
  end
end
