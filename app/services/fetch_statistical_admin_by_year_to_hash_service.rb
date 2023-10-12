class FetchStatisticalAdminByYearToHashService < ApplicationService
  attr_reader :data_hash, :data

  def initialize(data, data_hash)
    @data = data
    @data_hash = data_hash
  end

  def call
    @data[:total_job].each do |object|
      @data_hash[:total_job_hash][object.month.to_date.to_s] = object.count
    end
    @data[:total_base_user].each do |object|
      @data_hash[:total_base_user_hash][object.month.to_date.to_s] = object.count
    end
    @data[:total_kol].each do |object|
      @data_hash[:total_kol_hash][object.month.to_date.to_s] = object.count
    end
    @data[:total_report].each do |object|
      @data_hash[:total_report_hash][object.month.to_date.to_s] = object.count
    end
    @data_hash
  end
end
