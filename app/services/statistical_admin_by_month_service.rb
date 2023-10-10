class StatisticalAdminByMonthService < ApplicationService
  def initialize; end

  def call
    data = {}
    data[:days] = (Date.today.beginning_of_month..Date.today.end_of_month).to_a
    data[:total_job] = Job.within_current_month_details
    data[:total_base_user] = User.within_current_month_base
    data[:total_kol] = User.within_current_month_kol
    data[:total_report] = Report.within_current_month
    data
  end
end
