require_relative './module/statistical_module'
class StatisticalKolByTimeService < ApplicationService
  include StatisticalModule

  attr_reader :time, :kol_current_id

  def initialize(time, kol_current_id)
    @time = time
    @kol_current_id = kol_current_id
  end

  def call
    data = {}
    if @time.blank? || @time == 'month'
      data[:days] = (Date.today.beginning_of_month..Date.today.end_of_month).to_a
      data[:total_job] = Job.status_current_month_details('', @kol_current_id)
      data[:cancle_job] = Job.status_current_month_details('cancle', @kol_current_id)
      data[:finish_job] = Job.status_current_month_details('finish', @kol_current_id)
    elsif @time == 'half_year'
      data[:days] = get_last_6_months
      data[:total_job] = Job.status_half_years_details('', @kol_current_id)
      data[:cancle_job] = Job.status_half_years_details('cancle', @kol_current_id)
      data[:finish_job] = Job.status_half_years_details('finish', @kol_current_id)
    elsif @time == 'year'
      data[:days] = get_months_in_year(Time.now.year)
      data[:total_job] = Job.status_years_details('', @kol_current_id)
      data[:cancle_job] = Job.status_years_details('cancle', @kol_current_id)
      data[:finish_job] = Job.status_years_details('finish', @kol_current_id)
    end
    data
  end
end
