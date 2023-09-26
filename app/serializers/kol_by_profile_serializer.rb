class KolByProfileSerializer < BaseSerializer
  attributes :id, :fullname, :phone, :address, :status, :birthday

  attribute :avatar do |profile|
    if profile.avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(profile.avatar, only_path: true)
    else
      'null'
    end
  end

  attribute :kol do |profile|
    KolSerializer.new(profile)
  end
end
