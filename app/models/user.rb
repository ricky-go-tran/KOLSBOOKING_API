class User < ApplicationRecord
  EMAILS_ADMIN = %w[tdphat.study@gmail.com admin@admin.com].freeze

  rolify
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  has_one :profile
  has_one :kol_profile, through: :profile

  accepts_nested_attributes_for :profile

  before_create do
    unless has_role?(:admin)
      if EMAILS_ADMIN.include?(email)
        add_role(:admin)
      else
        add_role(:base)
      end
    end
  end

  def delete_roles
    roles.delete(roles.where(id: roles.ids))
  end
end
