class Bookmark < ApplicationRecord
  BOOKMARK_STATUS = %w[care attention extremely]

  resourcify
  belongs_to :job
  belongs_to :kol_profile

  validates :status, inclusion: { in: BOOKMARK_STATUS }
end
