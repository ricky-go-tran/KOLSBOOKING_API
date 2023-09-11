class Bookmark < ApplicationRecord
  belongs_to :job
  belongs_to :kol_profile

  validates :status, inclusion: { in: BOOKMARK_STATUS }
end
