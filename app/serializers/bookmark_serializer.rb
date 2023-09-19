class BookmarkSerializer < BaseSerializer
  attributes :id, :status

  attribute :job do |bookmark|
    JobSerializer.new(bookmark.job).as_json
  end
end
