# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  fullname   :string           not null
#  birthday   :date
#  phone      :string
#  address    :text
#  status     :string           default("valid")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  avatar_url :string
#  uid        :string
#  provider   :string
#  stripe_id  :string           default("none"), not null
#
class ProfileSerializer < BaseSerializer
  attributes :id, :fullname, :phone, :address, :birthday

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
