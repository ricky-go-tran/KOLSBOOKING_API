class NotificationPolicy < ApplicationPolicy
  def read?
    record.receiver_id == user.profile.id
  end

  class Scope < Scope
    def resolve
      scope.where(receiver_id: user.profile.id)
    end
  end
end
