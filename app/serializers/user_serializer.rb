class UserSerializer < BaseSerializer
  attributes :id, :email, :profile

  def profile
    profile = object&.profile
    {
      fullname: profile&.fullname,
      phone: profile&.phone,
      address: profile&.address,
      status: profile&.status,
      birthday: profile&.birthday
    }
  end
end
