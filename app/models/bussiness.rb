class Bussiness < ApplicationRecord
  belongs_to :profile
  validates :overview, :type_profile, presence: true
end
