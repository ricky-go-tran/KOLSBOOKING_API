# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  jti                    :string           not null
#  provider               :string
#  uid                    :string
#  status                 :string           default("invalid"), not null
#
class UserSerializer < BaseSerializer
  attributes :id, :email, :profile, :status

  attribute :profile do |user|
    ProfileSerializer.new(user.profile)
  end

  attribute :role do |user|
    if user.has_role?(:admin)
      'admin'
    elsif user.has_role?(:kol)
      'kol'
    else
      'base'
    end
  end
end
