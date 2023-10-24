class StatisticalAdminByMonthService < ApplicationService
  attr_reader :filter

  def initialize(filter)
    @filter = filter
  end

  def call
    data = {}
    year, month = @filter
    start_date = Date.new(year, month, 1).beginning_of_month
    end_date = start_date.end_of_month
    data[:days] = (start_date..end_date).to_a
    data[:total_job] = Job.within_current_month_details(@filter)
    data[:total_base_user] = User.within_current_month_base(@filter)
    data[:total_kol] = User.within_current_month_kol(@filter)
    data[:total_report] = Report.within_current_month(@filter)
    data
  end
end
