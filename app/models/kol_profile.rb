class KolProfile < ApplicationRecord
  belongs_to :profile
  has_many :bookmarks
  has_many :tasks
  has_many :industry_associations, as: :insdustry_associationable
  accepts_nested_attributes_for :industry_associations, allow_destroy: true
end
