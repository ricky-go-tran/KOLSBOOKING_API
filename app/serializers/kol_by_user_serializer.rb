class KolByUserSerializer < BaseSerializer
  attributes :id, :email, :profile

  attribute :profile do |user|
    ProfileSerializer.new(user.profile)
  end

  attribute :avatar do |user|
    if user.profile.avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(user.profile.avatar, only_path: true)
    else
      'null'
    end
  end

  attribute :like_num do |user|
    user.profile.emojied.where(status: 'like').count
  end

  attribute :unlike_num do |user|
    user.profile.emojied.where(status: 'unlike').count
  end

  attribute :follow_num do |user|
    user.profile.followed.count
  end
end
