class UserSerializer < BaseSerializer
  attributes :id, :email, :profile

  attribute :profile do |user|
    ProfileSerializer.new(user.profile)
  end
end
