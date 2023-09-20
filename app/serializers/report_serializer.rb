class ReportSerializer < BaseSerializer
  attributes :id, :title, :description, :created_at

  attribute :reporter do |report|
    ProfileSerializer.new(report.profile).as_json
  end
  # TODO: add reportable when add dependency
end
