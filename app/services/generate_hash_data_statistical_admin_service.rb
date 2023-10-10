class GenerateHashDataStatisticalAdminService < ApplicationService
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def call
    data_hash = {}
    data_hash[:total_job_hash] = Hash[@data[:days].map { |day| [day.to_s, 0] }]
    data_hash[:total_base_user_hash] = Hash[@data[:days].map { |day| [day.to_s, 0] }]
    data_hash[:total_kol_hash] = Hash[@data[:days].map { |day| [day.to_s, 0] }]
    data_hash[:total_report_hash] = Hash[@data[:days].map { |day| [day.to_s, 0] }]
    data_hash
  end
end
