class Report < ApplicationRecord
  REPORT_TITLE_LENGTH = 5..200
  REPORT_DESC_LENGTH = 10..3000
  REPORT_STATUS = %w[pending proccessing resovled rejected].freeze
  resourcify
  belongs_to :profile
  belongs_to :reportable, polymorphic: true

  validates :title, :description, presence: true
  validates :title, length: { in: REPORT_TITLE_LENGTH, message: I18n.t('report.error.title_length'), min_size: REPORT_TITLE_LENGTH.min, max_size: REPORT_TITLE_LENGTH.max }
  validates :description, length: { in: REPORT_DESC_LENGTH, message: I18n.t('report.error.desc_length'), min_size: REPORT_DESC_LENGTH.min, max_size: REPORT_DESC_LENGTH.max }

  scope :within_current_month, -> {
    where(created_at: Date.current.beginning_of_month..Date.current.end_of_month)
      .group('DATE(created_at)')
      .order('DATE(created_at)')
      .count
  }

  scope :within_current_year, -> {
    select("DATE_TRUNC('month', created_at) AS month, COUNT(*) AS count")
      .where(created_at: Date.current.beginning_of_year..Date.current.end_of_year)
      .group("DATE_TRUNC('month', created_at)")
      .order('month')
  }

  scope :within_six_months, -> {
    select("DATE_TRUNC('month', created_at) AS month, COUNT(*) AS count")
      .where(created_at: 6.months.ago.beginning_of_month..Date.current.end_of_month)
      .group("DATE_TRUNC('month', created_at)")
      .order('month')
  }
end
