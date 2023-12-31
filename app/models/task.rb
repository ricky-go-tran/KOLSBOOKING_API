# == Schema Information
#
# Table name: tasks
#
#  id             :bigint           not null, primary key
#  kol_profile_id :bigint           not null
#  title          :string           not null
#  start_time     :datetime         not null
#  end_time       :datetime         not null
#  status         :string           default("planning"), not null
#  description    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category       :string           default("personal"), not null
#
class Task < ApplicationRecord
  TASK_STATUS = %w[planning progress complete cancle].freeze
  TASK_CATEGORY = %w[personal web_job facebook_job tiktok_job youtube_job instgram_job other entertainment].freeze
  TASK_TITLE_LENGTH = 5..200
  TASK_DESC_LENGTH = 10..3000

  enum category_enum: TASK_CATEGORY

  resourcify
  belongs_to :kol_profile

  validates :title, :start_time, :end_time, :status, presence: true
  validates :category, inclusion: { in: TASK_CATEGORY }
  validates :status, inclusion: { in: TASK_STATUS }
  validates :title, length: { in: TASK_TITLE_LENGTH, message: I18n.t('task.error.title_length', min_size: TASK_TITLE_LENGTH.min, max_size: TASK_TITLE_LENGTH.max) }
  validates :description, length: { in: TASK_DESC_LENGTH, message: I18n.t('task.error.desc_length', min_size: TASK_DESC_LENGTH.min, max_size: TASK_DESC_LENGTH.max) }
  validate :start_time_must_be_before_end_time, on: %i[create update]

  private

  def start_time_must_be_before_end_time
    if start_time.present? && end_time.present? && start_time >= end_time
      errors.add(:end_time, I18n.t('task.error.start_before_end'))
    end
  end
end
