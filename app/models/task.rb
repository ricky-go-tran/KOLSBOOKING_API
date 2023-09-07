class Task < ApplicationRecord
  belongs_to :kol_profile

  validates :title, :start_time, :end_time, :status, presence: true
  validates :status, inclusion: { in: TASK_STATUS }
  validates :title, length: { in: TASK_TITLE_LENGTH, message: I18n.t('task.error.title_length', min_size: TASK_TITLE_LENGTH.min, max_size: TASK_TITLE_LENGTH.max) }
  validates :description, length: { in: TASK_DESC_LENGTH, message: I18n.t('task.error.desc_length', min_size: TASK_DESC_LENGTH.min, max_size: TASK_DESC_LENGTH.max) }
  validate :start_time_must_be_before_end_time

  private

  def start_time_must_be_before_end_time
    if start_time.present? && end_time.present? && start_time >= end_time
      errors.add(:end_time, I18n.t('task.error.start_before_end'))
    end
  end
end
