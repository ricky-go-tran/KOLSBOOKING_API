class BookmarkSerializer < BaseSerializer
  attributes :id, :status, :created_at

  attribute :job do |bookmark|
    JobSerializer.new(bookmark.job).as_json
  end
end
