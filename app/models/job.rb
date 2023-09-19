class Job < ApplicationRecord
  JOB_PRICE_MIN = 0
  JOB_TITLE_LENGTH = 5..200
  JOB_DESC_LENGTH = 10..3000
  JOB_STATUS = %w[post booking apply complete payment finish cancle].freeze

  resourcify
  belongs_to :profile
  has_many :bookmarks
  has_many :emojis, as: :emojiable

  validates :title, :price, :status, presence: true
  validates :price, numericality: { greater_than: JOB_PRICE_MIN, message: I18n.t('job.error.price_large_zero') }
  validates :status, inclusion: { in: JOB_STATUS }

  validates :title, length: { in: JOB_TITLE_LENGTH, message: I18n.t('job.error.title_length'), min_size: JOB_TITLE_LENGTH.min, max_size: JOB_TITLE_LENGTH.max }
  validates :description, length: { in: JOB_DESC_LENGTH, message: I18n.t('job.error.desc_length'), min_size: JOB_DESC_LENGTH.min, max_size: JOB_DESC_LENGTH.max }

  scope :total_current_month, ->(kol_id) {
    where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month, kol_id:)
  }

  scope :status_current_month, ->(kol_id, status) {
    where(status:, created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month, kol_id:)
  }
end
