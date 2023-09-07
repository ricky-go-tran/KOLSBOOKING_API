class Profile < ApplicationRecord
  has_one :kol_profile
  has_one_attached :avatar
  has_many :emojis, foreign_key: 'profile_id', class_name: 'Emoji'
  has_many :reports, foreign_key: 'profile_id', class_name: 'Report'
  has_many :jobs
  has_many :follower, class_name: 'Follower', foreign_key: 'follower_id'
  has_many :followed, class_name: 'Follower', foreign_key: 'followed_id'
  has_many :emojied, as: :emojiable, class_name: 'Emoji'
  has_many :reported, as: :reportable, class_name: 'Report'

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
