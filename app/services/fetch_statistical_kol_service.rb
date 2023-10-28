class FetchStatisticalKolService < ApplicationService
  attr_reader :data_hash, :data, :time

  def initialize(data, data_hash, time)
    @data = data
    @data_hash = data_hash
    @time = time
  end

  def call
    if ['half_year', 'year'].include?(@time)
      @data[:total_job].each do |object|
        @data_hash[:total_job][object.month.to_date.to_s] = object.count
      end
      @data[:cancle_job].each do |object|
        @data_hash[:cancle_job][object.month.to_date.to_s] = object.count
      end
      @data[:finish_job].each do |object|
        @data_hash[:finish_job][object.month.to_date.to_s] = object.count
      end
    else
      @data[:total_job].each do |date, count|
        @data_hash[:total_job][date.to_s] = count
      end
      @data[:cancle_job].each do |date, count|
        @data_hash[:cancle_job][date.to_s] = count
      end
      @data[:finish_job].each do |date, count|
        @data_hash[:finish_job][date.to_s] = count
      end
    end
    @data_hash
  end
end
