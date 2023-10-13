# == Schema Information
#
# Table name: reports
#
#  id              :bigint           not null, primary key
#  title           :string           not null
#  description     :text             not null
#  reportable_type :string           not null
#  reportable_id   :bigint           not null
#  profile_id      :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :string           default("pending")
#
class ReportSerializer < BaseSerializer
  attributes :id, :title, :description, :status, :created_at

  attribute :reporter do |report|
    ProfileSerializer.new(report.profile).as_json
  end
  # TODO: add reportable when add dependency
end
