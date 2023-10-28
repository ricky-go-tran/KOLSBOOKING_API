class NotificationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(receiver_id: user.profile.id)
    end
  end
end
