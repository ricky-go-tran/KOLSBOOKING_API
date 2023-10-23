class Review < ApplicationRecord
  belongs_to :reviewer, class_name: 'Profile'
  belongs_to :reviewed, class_name: 'Profile'
end
