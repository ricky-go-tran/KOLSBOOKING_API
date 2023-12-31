# == Schema Information
#
# Table name: reports
#
#  id              :bigint           not null, primary key
#  title           :string           not null
#  description     :text             not null
#  reportable_type :string           not null
#  reportable_id   :bigint           not null
#  profile_id      :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :string           default("pending")
#
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

  scope :within_current_month, ->(filter) {
    year, month = filter
    start_date = Date.new(year, month, 1).beginning_of_month
    end_date = start_date.end_of_month
    where(created_at: start_date..end_date)
      .group('DATE(created_at)')
      .order('DATE(created_at)')
      .count
  }

  scope :within_current_year, ->(year) {
    select("DATE_TRUNC('month', created_at) AS month, COUNT(*) AS count")
      .where(created_at: Date.new(year, 1, 1)..Date.new(year, 12, 31))
      .group("DATE_TRUNC('month', created_at)")
      .order('month')
  }

  scope :within_six_months, -> {
    select("DATE_TRUNC('month', created_at) AS month, COUNT(*) AS count")
      .where(created_at: 6.months.ago.beginning_of_month..Date.current.end_of_month)
      .group("DATE_TRUNC('month', created_at)")
      .order('month')
  }

  scope :search_by_title, ->(search) { where('title ILIKE ?', "%#{search}%") }
end
