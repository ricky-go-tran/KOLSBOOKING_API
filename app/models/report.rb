class Report < ApplicationRecord
  belongs_to :objective
  belongs_to :profile

  validates :title, :description, presence: true
  validates :title, length: { in: 5..200, message: 'Title\' length from 5 to 200' }
  validates :description, length: { in: 10..3000, message: 'Description\' length from 10 to 3000' }
end
