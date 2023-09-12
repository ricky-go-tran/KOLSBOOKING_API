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

  before_create do
    if EMAILS_ADMIN.include?(email)
      add_role(:admin)
    else
      add_role(:base)
    end
  end
end
