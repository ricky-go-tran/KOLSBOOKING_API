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
  has_many :industry_associations, as: :insdustry_associationable
  accepts_nested_attributes_for :industry_associations, allow_destroy: true

  validates :title, :price, :status, presence: true
  validates :price, numericality: { greater_than: JOB_PRICE_MIN, message: I18n.t('job.error.price_large_zero') }
  validates :status, inclusion: { in: JOB_STATUS }

  validates :title, length: { in: JOB_TITLE_LENGTH, message: I18n.t('job.error.title_length'), min_size: JOB_TITLE_LENGTH.min, max_size: JOB_TITLE_LENGTH.max }
  validates :description, length: { in: JOB_DESC_LENGTH, message: I18n.t('job.error.desc_length'), min_size: JOB_DESC_LENGTH.min, max_size: JOB_DESC_LENGTH.max }
  validates :image, size: { less_than: IMAGE_MAX_SIZE, message: I18n.t('genaral.error.image_size', max_size: IMAGE_MAX_SIZE) },
                    content_type: { in: IMAGE_TYPE_SUPPORT, message: I18n.t('genaral.error.image_type') }

  scope :within_current_month_details, -> {
    where(created_at: Date.current.beginning_of_month..Date.current.end_of_month)
      .group('DATE(created_at)')
      .order('DATE(created_at)')
      .count
  }

  scope :within_current_year_details, -> {
    select("DATE_TRUNC('month', created_at) AS month, COUNT(*) AS count")
      .where(created_at: Date.current.beginning_of_year..Date.current.end_of_year)
      .group("DATE_TRUNC('month', created_at)")
      .order('month')
  }

  scope :within_six_months_details, -> {
    select("DATE_TRUNC('month', created_at) AS month, COUNT(*) AS count")
      .where(created_at: 6.months.ago.beginning_of_month..Date.current.end_of_month)
      .group("DATE_TRUNC('month', created_at)")
      .order('month')
  }

  scope :status_current_month_details, ->(status, kol_id) {
    where_by_status(status).where(created_at: Time.current.beginning_of_month..Time.current.end_of_month, kol_id:)
      .group('DATE(created_at)')
      .order('DATE(created_at)')
      .count
  }

  scope :status_half_years_details, ->(status, kol_id) {
    select("DATE_TRUNC('month', created_at) AS month, COUNT(*) AS count")
      .where_by_status(status).where(created_at: 6.months.ago.beginning_of_month..Date.current.end_of_month, kol_id:)
      .group("DATE_TRUNC('month', created_at)")
      .order('month')
  }

  scope :status_years_details, ->(status, kol_id) {
    select("DATE_TRUNC('month', created_at) AS month, COUNT(*) AS count")
      .where_by_status(status).where(created_at: Date.current.beginning_of_year..Date.current.end_of_year, kol_id:)
      .group("DATE_TRUNC('month', created_at)")
      .order('month')
  }

  scope :job_by_industry, ->(industries) {
    joins("INNER JOIN industry_associations ON insdustry_associationable_id = jobs.id AND insdustry_associationable_type = 'Job'")
      .where('industry_associations.industry_id IN (?)', industries.join(', ').to_s)
  }

  scope :where_get_by_status, ->(status) {
    if status == 'post'
      where(status: ['post', 'booking'])
    elsif status == 'complete'
      where(status: ['complete', 'payment'])
    else
      where(status:)
    end
  }

  def self.where_by_status(status)
    if status.present?
      where(status:)
    else
      all
    end
  end
end
