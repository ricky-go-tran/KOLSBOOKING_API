class ProfileSerializer < BaseSerializer
  attributes :id, :fullname, :phone, :address, :status, :birthday

  def avatar_img
    if object.avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(object.avatar, only_path: true)
    end
  end
end
