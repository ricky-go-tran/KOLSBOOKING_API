class Profile < ApplicationRecord
  has_one :kol_profile
  has_one_attached :avatar
  has_many :emojis
  has_many :reports
  has_many :jobs
  has_many :follower, class: "Follower", foreign_key: 'follower_id'
  has_many :followed, class: "Follower", foreign_key: 'followed_id'


  validates :fullname, :status, presence: true
  validates :phone, length: { is: 10, message: "Phone's length must 10" }
  validates :fullname, length: { in: 4..20, message: 'Name\'s lengths from 5 to 200 ' }
  validates :address, length: { in: 5..200, message: 'Length of address from 5 to 200 ' }
  validates :avatar, attached: true, size: { less_than: 10.megabytes, message: 'Please choose a photo smaller than 10mb' }, content_type: { in: %w[image/png image/jpeg], message: "It isn't a image" }
  validate :check_birtday_furture
  validate :check_age_enough


  private

  def check_birtday_furture
    if birthday.future?
      errors.add(:birthday, "Birthday can't future")
    end
  end

  def check_age_enough
    if (Time.now - birthday) > 16.years
      errors.add(:birthday, "User enough not age")
    end
  end
end
