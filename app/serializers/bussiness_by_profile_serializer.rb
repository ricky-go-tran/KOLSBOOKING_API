class BussinessByProfileSerializer < BaseSerializer
  attributes :id, :fullname, :phone, :address, :status, :birthday

  attribute :email do |profile|
    profile.user.email
  end

  attribute :avatar do |profile|
    if profile.avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(profile.avatar, only_path: true)
    else
      'null'
    end
  end

  attribute :bussiness do |profile|
    BussinessSerializer.new(profile.kol_profile)
  end
end
