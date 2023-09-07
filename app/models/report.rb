class Report < ApplicationRecord
  resourcify
  belongs_to :objective
  belongs_to :profile
  belongs_to :reportable, polymorphic: true

  validates :title, :description, presence: true
  validates :title, length: { in: REPORT_TITLE_LENGTH, message: I18n.t('report.error.title_length'), min_size: REPORT_TITLE_LENGTH.min, max_size: REPORT_TITLE_LENGTH.max }
  validates :description, length: { in: REPORT_DESC_LENGTH, message: I18n.t('report.error.desc_length'), min_size: REPORT_DESC_LENGTH.min, max_size: REPORT_DESC_LENGTH.max }
end
