class Job < ApplicationRecord
  JOB_PRICE_MIN = 0
  JOB_TITLE_LENGTH = 5..200
  IMAGE_MAX_SIZE = 10.megabytes
  IMAGE_TYPE_SUPPORT = %w[image/png image/jpeg].freeze
  JOB_DESC_LENGTH = 10..3000
  JOB_STATUS = %w[post booking apply complete payment finish cancle].freeze

  resourcify
  belongs_to :profile
  has_one_attached :image
  has_many :bookmarks
  has_many :emojis, as: :emojiable

  validates :title, :price, :status, presence: true
  validates :price, numericality: { greater_than: JOB_PRICE_MIN, message: I18n.t('job.error.price_large_zero') }
  validates :status, inclusion: { in: JOB_STATUS }

  validates :title, length: { in: JOB_TITLE_LENGTH, message: I18n.t('job.error.title_length'), min_size: JOB_TITLE_LENGTH.min, max_size: JOB_TITLE_LENGTH.max }
  validates :description, length: { in: JOB_DESC_LENGTH, message: I18n.t('job.error.desc_length'), min_size: JOB_DESC_LENGTH.min, max_size: JOB_DESC_LENGTH.max }
  validates :image, size: { less_than: IMAGE_MAX_SIZE, message: I18n.t('genaral.error.image_size', max_size: IMAGE_MAX_SIZE) },
                    content_type: { in: IMAGE_TYPE_SUPPORT, message: I18n.t('genaral.error.image_type') }

  scope :total_current_month, ->(kol_id) {
    where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month, kol_id:)
  }

  scope :status_current_month, ->(params) {
    where(status: params[:status], created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month, kol_id: params[:kol_id])
  }

  scope :status_current_month_details, ->(params) {
    where(status: params[:status], created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month, kol_id: params[:kol_id])
      .group('DATE(created_at)')
      .order('DATE(created_at)')
      .count
  }
end
