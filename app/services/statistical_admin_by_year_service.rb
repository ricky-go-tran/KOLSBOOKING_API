require_relative './module/statistical_module'
class StatisticalAdminByYearService < ApplicationService
  include Module::StatisticalModule

  attr_reader :filter

  def initialize(filter)
    @filter = filter
  end

  def call
    data = {}
    data[:total_job] = Job.within_current_year_details(@filter)
    data[:days] = get_months_in_year(@filter)
    data[:total_base_user] = User.within_current_year_base(@filter)
    data[:total_kol] = User.within_current_year_kol(@filter)
    data[:total_report] = Report.within_current_year(@filter)
    data
  end
end
