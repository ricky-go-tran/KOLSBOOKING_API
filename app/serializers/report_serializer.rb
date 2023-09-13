class ReportSerializer < BaseSerializer
  attributes :id, :title, :description

  attribute :reporter do |report|
    ProfileSerializer.new(report.profile).as_json
  end
  # TODO: add reportable when add dependency
end
