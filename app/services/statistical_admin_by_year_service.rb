require_relative './module/statistical_module'
class StatisticalAdminByYearService < ApplicationService
  include Module::StatisticalModule
  def initialize; end

  def call
    data = {}
    data[:total_job] = Job.within_current_year_details
    data[:days] = get_months_in_year(Time.now.year)
    data[:total_base_user] = User.within_current_year_base
    data[:total_kol] = User.within_current_year_kol
    data[:total_report] = Report.within_current_year
    data
  end
end
