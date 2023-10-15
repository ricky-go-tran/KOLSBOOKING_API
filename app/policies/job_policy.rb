class JobPolicy < ApplicationPolicy
  def show?
    record.status == 'post'
  end

  class Scope < Scope
    def resolve
      scope.includes(:industry_associations, :emojis, :bookmarks, { image_attachment: :blob }, profile: [:google_integrate, :user, { avatar_attachment: :blob }]).where(status: 'post')
    end
  end
end
