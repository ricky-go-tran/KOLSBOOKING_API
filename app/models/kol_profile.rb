class KolProfile < ApplicationRecord
  belongs_to :profile
  has_many :bookmarks
  has_many :tasks
end
