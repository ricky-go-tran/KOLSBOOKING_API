require_relative './module/statistical_module'
class StatisticalAdminByHalfYearService < ApplicationService
  include Module::StatisticalModule
  def initialize; end

  def call
    data = {}
    data[:total_job] = Job.within_six_months_details
    data[:days] = get_last_6_months
    data[:total_base_user] = User.within_six_months_base
    data[:total_kol] = User.within_six_months_kol
    data[:total_report] = Report.within_six_months
    data
  end
end
