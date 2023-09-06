class Task < ApplicationRecord
  belongs_to :kol_profile

  validates :title, :start_time, :end_time, :status, presence: true
  validates :status, inclusion: { in: %w[planning progress complete cancle] }
  validates :title, length: { in: 5..200, message: 'Title\' length from 5 to 200' }
  validates :description, length: { in: 10..3000, message: 'Description\' length from 10 to 3000' }
  validate :start_time_must_be_before_end_time

  private

  def start_time_must_be_before_end_time
    if start_time.present? && end_time.present? && start_time >= end_time
      errors.add(:end_time, 'Must be after start time')
    end
  end
end
