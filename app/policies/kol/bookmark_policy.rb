class Kol::BookmarkPolicy < ApplicationPolicy
  def unmark?
    user.profile.kol_profile.id == record.kol_profile_id
  end

  def mark?
    user.has_role?(:kol)
  end

  class Scope < Scope
    def resolve
      scope.includes(job: [{ image_attachment: :blob }, profile: [:google_integrate, :user, { avatar_attachment: :blob }]]).where(kol_profile_id: user.profile.kol_profile)
    end
  end
end
