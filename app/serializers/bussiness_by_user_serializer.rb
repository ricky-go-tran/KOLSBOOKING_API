class BussinessByUserSerializer < BaseSerializer
  attributes :id, :email

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

  attribute :job_num do |user|
    user.profile.jobs.where(status: 'post').count
  end

  attribute :review_num do |user|
    user.profile.reviewed.count
  end

  attribute :bussiness do |user|
    user.profile.bussiness
  end
end
