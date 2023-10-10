class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'Profile'
  belongs_to :receiver, class_name: 'Profile'

  validates :title, :description, presence: true
end
