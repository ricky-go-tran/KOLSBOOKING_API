class UserSerializer < BaseSerializer
  attributes :id, :email, :profile

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
