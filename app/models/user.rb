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

  scope :within_current_month_base, -> {
    subquery = joins(:roles)
    .where(roles: { name: 'base' })
    .where(users: { created_at: Date.current.beginning_of_month..Date.current.end_of_month })
    .group('DATE(users.created_at)')
    .order('DATE(users.created_at)')
    .select("DATE(users.created_at) AS date, COUNT(*) AS count")

  from(subquery, :users)

  }

  scope :within_current_year_base, -> {
    joins(:roles).select("DATE_TRUNC('month', users.created_at) AS month, COUNT(*) AS count")
      .where(roles: {name: 'base'}).where(created_at: Date.current.beginning_of_year..Date.current.end_of_year)
      .group("DATE_TRUNC('month', users.created_at)")
      .order('month')
  }

  scope :within_six_months_base, -> {
    joins(:roles).select("DATE_TRUNC('month', users.created_at) AS month, COUNT(*) AS count")
      .where(roles: {name: 'base'}).where(created_at: 6.months.ago.beginning_of_month..Date.current.end_of_month)
      .group("DATE_TRUNC('month', users.created_at)")
      .order('month')
  }

  scope :within_current_month_kol, -> {
    subquery = joins(:roles)
    .where(roles: { name: 'kol' })
    .where(users: { created_at: Date.current.beginning_of_month..Date.current.end_of_month })
    .group('DATE(users.created_at)')
    .order('DATE(users.created_at)')
    .select("DATE(users.created_at) AS date, COUNT(*) AS count")

  from(subquery, :users)
  }

  scope :within_current_year_kol, -> {
    joins(:roles).select("DATE_TRUNC('month', users.created_at) AS month, COUNT(*) AS count")
      .where(roles: {name: 'kol'}).where(created_at: Date.current.beginning_of_year..Date.current.end_of_year)
      .group("DATE_TRUNC('month', users.created_at)")
      .order('month')
  }

  scope :within_six_months_kol, -> {
    joins(:roles).select("DATE_TRUNC('month', users.created_at) AS month, COUNT(*) AS count")
      .where(roles: {name: 'kol'}).where(created_at: 6.months.ago.beginning_of_month..Date.current.end_of_month)
      .group("DATE_TRUNC('month', users.created_at)")
      .order('month')
  }



  def delete_roles
    roles.delete(roles.where(id: roles.ids))
  end

  def self.from_omniauth_google(auth)

    where( uid: auth['sub']).first_or_create do |user|
      user.provider = "google_oauth2"
      user.email = auth['email']
      user.password = Devise.friendly_token[0, 20]
      user.password_confirmation = user.password
      #Profile.create!(fullname: auth.['name'], birthday: (Time.zone.now - 20.years), address: "Testing  efjeinf iejdiefn fiejfijei fiefjie fiefjie fe", phone: '12345667890')
    end
  end
end
