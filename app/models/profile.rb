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
class Profile < ApplicationRecord
  MIN_AGE = 16.years
  IMAGE_MAX_SIZE = 10.megabytes
  IMAGE_TYPE_SUPPORT = %w[image/png image/jpeg].freeze
  PHONE_LENGTH = 10
  PROFILE_FULLNAME_LENGTH = 4..20
  PROFILE_ADDRESS_LENGTH = 5..200
  PROFILE_STATUS = %w[valid invalid lock].freeze

  belongs_to :user
  has_one :kol_profile
  has_one :google_integrate
  has_one_attached :avatar
  has_many :emojis, foreign_key: 'profile_id', class_name: 'Emoji'
  has_many :reports, foreign_key: 'profile_id', class_name: 'Report'
  has_many :jobs
  has_many :follower, class_name: 'Follower', foreign_key: 'follower_id'
  has_many :followed, class_name: 'Follower', foreign_key: 'followed_id'
  has_many :sender, class_name: 'Notification', foreign_key: 'sender_id'
  has_many :receiver, class_name: 'Notification', foreign_key: 'receiver_id'
  has_many :emojied, as: :emojiable, class_name: 'Emoji'
  has_many :reported, as: :reportable, class_name: 'Report'

  before_validation :create_on_stripe, on: :create
  accepts_nested_attributes_for :kol_profile

  validates :fullname, :birthday, presence: true
  validates :phone, length: { is: PHONE_LENGTH, message: I18n.t('profile.error.phone_legth', phone_size: PHONE_LENGTH) }
  validates :fullname, length: {
    in: PROFILE_FULLNAME_LENGTH,
    message: I18n.t('profile.error.full_name_length',
                    min_size: PROFILE_FULLNAME_LENGTH.min,
                    max_size: PROFILE_FULLNAME_LENGTH.max)
  }
  validates :address, length: {
    in: PROFILE_ADDRESS_LENGTH,
    message: I18n.t('profile.error.address_length',
                    min_size: PROFILE_ADDRESS_LENGTH.min,
                    max_size: PROFILE_ADDRESS_LENGTH.max)
  }
  validates :avatar, size: { less_than: IMAGE_MAX_SIZE, message: I18n.t('genaral.error.image_size', max_size: IMAGE_MAX_SIZE) },
                     content_type: { in: IMAGE_TYPE_SUPPORT, message: I18n.t('genaral.error.image_type') }
  validate :check_birtday_furture, on: %i[create update]
  validate :check_age_enough, on: %i[create update]

  after_create :update_user_status

  private

  def update_user_status
    user.update(status: 'valid') if user.present?
  end

  def check_birtday_furture
    if birthday&.future?
      errors.add(:birthday, I18n.t('profile.error.birthday_future'))
    end
  end

  def check_age_enough
    if birthday.present? && (((Time.now.to_date - birthday.to_date) / 365).floor > MIN_AGE)
      errors.add(:birthday, I18n.t('profile.error.old_enough'))
    end
  end

  def create_on_stripe
    user = User.find_by(id: user_id)
    params = { email: user.email, name: fullname }
    response = Stripe::Customer.create(params)
    self.stripe_id = response.id
  end
end
