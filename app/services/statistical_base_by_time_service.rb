require_relative './module/statistical_module'
class StatisticalBaseByTimeService < ApplicationService
  include Module::StatisticalModule

  attr_reader :time, :current_user, :filter

  def initialize(time, current_user, filter)
    @time = time
    @current_user = current_user
    @filter = filter
  end

  def call
    data = {}
    if @time.blank? || @time == 'month'
      year, month = @filter
      start_date = Date.new(year, month, 1).beginning_of_month
      end_date = start_date.end_of_month
      data[:days] = (start_date..end_date).to_a
      data[:total_job] = Job.status_current_month_by_base_details('', @current_user, @filter)
      data[:cancle_job] = Job.status_current_month_by_base_details('cancle', @current_user, @filter)
      data[:finish_job] = Job.status_current_month_by_base_details('finish', @current_user, @filter)
    elsif @time == 'half_year'
      data[:days] = get_last_6_months
      data[:total_job] = Job.status_half_years_by_base_details('', @current_user)
      data[:cancle_job] = Job.status_half_years_by_base_details('cancle', @current_user)
      data[:finish_job] = Job.status_half_years_by_base_details('finish', @current_user)
    elsif @time == 'year'
      data[:days] = get_months_in_year(@filter)
      data[:total_job] = Job.status_years_by_base_details('', @current_user, @filter)
      data[:cancle_job] = Job.status_years_by_base_details('cancle', @current_user, @filter)
      data[:finish_job] = Job.status_years_by_base_details('finish', @current_user, @filter)
    end
    data
  end
end
