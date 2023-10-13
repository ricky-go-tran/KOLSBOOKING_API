# == Schema Information
#
# Table name: bookmarks
#
#  id             :bigint           not null, primary key
#  kol_profile_id :bigint           not null
#  job_id         :bigint           not null
#  status         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Bookmark < ApplicationRecord
  BOOKMARK_STATUS = %w[care attention extremely].freeze

  resourcify
  belongs_to :job
  belongs_to :kol_profile

  validates :status, inclusion: { in: BOOKMARK_STATUS }
end
