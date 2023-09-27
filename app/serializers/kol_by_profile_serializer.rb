class KolByProfileSerializer < BaseSerializer
  attributes :id, :fullname, :phone, :address, :status, :birthday

  attrubute :email do |profile|
    profile.user.email
  end

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

  attribute :like_num do |profile|
    profile.emojis.where(status: 'like').count
  end

  attribute :unlike_num do |profile|
    profile.emojis.where(status: 'unlike').count
  end

  attribute :follow_num do |profile|
    profile.followed.count
  end

  attribute :industry do |profile|
    IndustryWithoutDescriptionSerializer.new(
      profile.industry_associations.map { |association| association.industry }
    )
  end


end
