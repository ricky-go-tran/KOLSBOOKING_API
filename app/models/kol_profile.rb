class KolProfile < ApplicationRecord
  belongs_to :profile
  has_many :bookmarks
  has_many :tasks
  has_many :industry_associations, as: :insdustry_associationable
end
