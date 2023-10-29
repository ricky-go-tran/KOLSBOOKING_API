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

  scope :within_current_month_base, -> (filter){
    year = filter[0]
    month = filter[1]
    start_date = Date.new(year, month, 1).beginning_of_month
    end_date = start_date.end_of_month
    joins(:roles)
    .where(roles: { name: 'base' })
    .where(users: { created_at: start_date..end_date })
    .group('DATE(users.created_at)')
    .order('DATE(users.created_at)')
    .select("DATE(users.created_at) AS date, COUNT(*) AS count")

  }

  scope :within_current_year_base, ->(year) {
    joins(:roles).select("DATE_TRUNC('month', users.created_at) AS month, COUNT(*) AS count")
      .where(roles: {name: 'base'}).where(created_at: Date.new(year, 1, 1)..Date.new(year, 12, 31))
      .group("DATE_TRUNC('month', users.created_at)")
      .order('month')
  }

  scope :within_six_months_base, -> {
    joins(:roles).select("DATE_TRUNC('month', users.created_at) AS month, COUNT(*) AS count")
      .where(roles: {name: 'base'}).where(created_at: 6.months.ago.beginning_of_month..Date.current.end_of_month)
      .group("DATE_TRUNC('month', users.created_at)")
      .order('month')
  }

  scope :within_current_month_kol, ->(filter) {
    year, month = filter
    start_date = Date.new(year, month, 1).beginning_of_month
    end_date = start_date.end_of_month
    subquery = joins(:roles)
    .where(roles: { name: 'kol' })
    .where(users: { created_at: start_date..end_date })
    .group('DATE(users.created_at)')
    .order('DATE(users.created_at)')
    .select("DATE(users.created_at) AS date, COUNT(*) AS count")

  from(subquery, :users)
  }

  scope :within_current_year_kol, ->(year) {
    joins(:roles).select("DATE_TRUNC('month', users.created_at) AS month, COUNT(*) AS count")
      .where(roles: {name: 'kol'}).where(created_at: Date.new(year, 1, 1)..Date.new(year, 12, 31))
      .group("DATE_TRUNC('month', users.created_at)")
      .order('month')
  }

  scope :within_six_months_kol, -> {
    joins(:roles).select("DATE_TRUNC('month', users.created_at) AS month, COUNT(*) AS count")
      .where(roles: {name: 'kol'}).where(created_at: 6.months.ago.beginning_of_month..Date.current.end_of_month)
      .group("DATE_TRUNC('month', users.created_at)")
      .order('month')
  }

  scope :filter_follow, ->(filter) {
    follower_min = filter[:follow][:min]
    follower_max = filter[:follow][:max]
    joins(:profile).joins("INNER JOIN followers ON profiles.id = followers.followed_id").group('users.id').having('COUNT(followers.id) BETWEEN ? AND ?', follower_min, follower_max)
  }

  scope :filter_like, ->(filter) {
    like_min = filter[:like][:min]
    like_max = filter[:like][:max]
    joins(:profile).joins("INNER JOIN emojis ON emojiable_id = profiles.id AND emojiable_type = 'Profile' AND emojis.status ='like'").group('users.id').having('COUNT(emojis.id) BETWEEN ? AND ?', like_min, like_max)
  }

   scope :filter_industry, ->(filter) {
    industries = filter[:industry]
    joins(profile: :kol_profile).joins("INNER JOIN industry_associations ON insdustry_associationable_id = kol_profiles.id AND insdustry_associationable_type = 'KolProfile'").where('industry_associations.industry_id IN (?)', industries.as_json.values).group('users.id')
  }
  scope :get_all_businesses_valid, -> {with_role(:base).includes(profile: [:followed, :follower, { avatar_attachment: :blob }]).joins(:profile).where("profiles.status = 'valid'")}
  scope :search_bussiness_by_fullname, ->(search) { joins(:profile).where('profiles.fullname ILIKE ?', "%#{search}%")}
  scope :search_bussiness_by_status, -> (status) { joins(profile: :bussiness).where('bussinesses.type_profile ILIKE ?', "%#{status}%")}


  scope :get_all_kols_valid, -> { with_role(:kol).includes(profile: [:followed, :follower, { avatar_attachment: :blob }]).joins(:profile).where("profiles.status = 'valid'") }
   scope :search_kols_by_fullname, ->(search) { where('profiles.fullname ILIKE ?', "%#{search}%")}


  def delete_roles
    roles.delete(roles.where(id: roles.ids))
  end
end
