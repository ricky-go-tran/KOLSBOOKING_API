class Job < ApplicationRecord
  belongs_to :profile
  has_many :bookmarks

  validates :title, :price, :status, presence: true
  validates :price, numericality: { greater_than: 0, message: 'Greater than 0' }
  validates :status, inclusion: { in: %w[post booking apply complete payment finish cancle] }
  validates :title, length: { in: 5..200, message: 'Title\' length from 5 to 200 ' }
  validates :description, length: { in: 10..3000, message: 'Description\' length from 10 to 3000 ' }
end
