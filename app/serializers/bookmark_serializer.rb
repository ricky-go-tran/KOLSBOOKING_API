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
class BookmarkSerializer < BaseSerializer
  attributes :id, :status, :created_at

  attribute :job do |bookmark|
    JobSerializer.new(bookmark.job).as_json
  end
end
