class Profile < ApplicationRecord
  MIN_AGE = 16.years
  IMAGE_MAX_SIZE = 10.megabytes
  IMAGE_TYPE_SUPPORT = %w[image/png image/jpeg].freeze
  PHONE_LENGTH = 10
  PROFILE_FULLNAME_LENGTH = 4..20
  PROFILE_ADDRESS_LENGTH = 5..200

  has_one :kol_profile
  has_one_attached :avatar
  has_many :emojis
  has_many :reports
  has_many :jobs
  has_many :follower, class: 'Follower', foreign_key: 'follower_id'
  has_many :followed, class: 'Follower', foreign_key: 'followed_id'

  validates :fullname, :status, presence: true
  validates :phone, length: { is: PHONE_LENGTH, message: I18n.t('profile.error.phone_legth', phone_size: PHONE_LENGTH) }
  validates :fullname, length: { in: PROFILE_FULLNAME_LENGTH, message: I18n.t('profile.error.full_name_length', min_size: PROFILE_FULLNAME_LENGTH.min, max_size: PROFILE_FULLNAME_LENGTH.max) }
  validates :address, length: { in: PROFILE_ADDRESS_LENGTH, message: I18n.t('profile.error.address_legth', min_size: PROFILE_ADDRESS_LENGTH.min, max_size: PROFILE_ADDRESS_LENGTH.max) }
  validates :avatar, attached: true,
                     size: { less_than: IMAGE_MAX_SIZE, message: I18n.t('genaral.error.image_size', max_size: IMAGE_MAX_SIZE) },
                     content_type: { in: IMAGE_TYPE_SUPPORT, message: I18n.t('genaral.error.image_type') }
  validate :check_birtday_furture
  validate :check_age_enough

  private

  def check_birtday_furture
    if birthday.future?
      errors.add(:birthday, I18n.t('profile.error.birthday_future'))
    end
  end

  def check_age_enough
    if (Time.now - birthday) > MIN_AGE
      errors.add(:birthday, I18n.t('profile.error.old_enough'))
    end
  end
end
