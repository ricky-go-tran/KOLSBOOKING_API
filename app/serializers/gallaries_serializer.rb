class GallariesSerializer < BaseSerializer
  attribute :gallaries do |profile|
    images = profile.kol_profile.gallaries.map do |image|
      {
        id: image.id,
        src: Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true),
        width: 1200,
        height: 560
      }
    end
    images
  end
end
