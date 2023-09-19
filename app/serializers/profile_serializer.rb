class ProfileSerializer < BaseSerializer
  attributes :id, :fullname, :phone, :address, :status, :birthday

  attribute :avatar do |profile|
    if profile.avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(profile.avatar, only_path: true)
    else
      'null'
    end
  end

  attribute :role do |profile|
    user = profile.user
    if user.has_role?(:admin)
      'admin'
    elsif user.has_role?(:kol)
      'kol'
    else
      'base'
    end
  end
end
