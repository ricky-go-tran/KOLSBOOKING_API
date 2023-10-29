class FetchStatisticalAdminByMonthToHashService < ApplicationService
  attr_reader :data_hash, :data

  def initialize(data, data_hash)
    @data = data
    @data_hash = data_hash
  end

  def call
    @data[:total_job].each do |date, count|
      @data_hash[:total_job_hash][date.to_s] = count
    end
    @data[:total_base_user].each do |object|
      @data_hash[:total_base_user_hash][object.date.to_date.to_s] = object.count
    end
    @data[:total_kol].each do |object|
      @data_hash[:total_kol_hash][object.date.to_date.to_s] = object.count
    end
    @data[:total_report].each do |date, count|
      @data_hash[:total_report_hash][date.to_s] = count
    end
    @data_hash
  end
end
