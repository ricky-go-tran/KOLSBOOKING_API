require_relative './module/statistical_module'
class StatisticalKolByTimeService < ApplicationService
  include Module::StatisticalModule

  attr_reader :time, :kol_current_id, :filter

  def initialize(time, kol_current_id, filter)
    @time = time
    @kol_current_id = kol_current_id
    @filter = filter
  end

  def call
    data = {}
    if @time.blank? || @time == 'month'

      year, month = @filter
      start_date = Date.new(year, month, 1).beginning_of_month
      end_date = start_date.end_of_month
      data[:days] = (start_date..end_date).to_a
      data[:total_job] = Job.status_current_month_details('', @kol_current_id, @filter)
      data[:cancle_job] = Job.status_current_month_details('cancle', @kol_current_id, @filter)
      data[:finish_job] = Job.status_current_month_details('finish', @kol_current_id, @filter)
    elsif @time == 'half_year'
      data[:days] = get_last_6_months
      data[:total_job] = Job.status_half_years_details('', @kol_current_id)
      data[:cancle_job] = Job.status_half_years_details('cancle', @kol_current_id)
      data[:finish_job] = Job.status_half_years_details('finish', @kol_current_id)
    elsif @time == 'year'
      data[:days] = get_months_in_year(@filter)
      data[:total_job] = Job.status_years_details('', @kol_current_id, @filter)
      data[:cancle_job] = Job.status_years_details('cancle', @kol_current_id, @filter)
      data[:finish_job] = Job.status_years_details('finish', @kol_current_id, @filter)
    end
    data
  end
end
