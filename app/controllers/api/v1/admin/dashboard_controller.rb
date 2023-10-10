class Api::V1::Admin::DashboardController < ApplicationController
  def index
    tab = params[:tab]
    if tab.blank? || tab == 'month'
      days = (Date.today.beginning_of_month..Date.today.end_of_month).to_a
      total_job = Job.within_current_month_details
      total_base_user = User.within_current_month_base
      total_kol = User.within_current_month_kol
      total_report = Report.within_current_month
    elsif tab == 'half_year'
      total_job = Job.within_six_months_details
      days = get_last_6_months
      total_base_user = User.within_six_months_base
      total_kol = User.within_six_months_kol
      total_report = Report.within_six_months
    elsif tab == 'year'
      total_job = Job.within_current_year_details
      days = get_months_in_year(Time.now.year)
      total_base_user = User.within_current_year_base
      total_kol = User.within_current_year_kol
      total_report = Report.within_current_year
    end

    total_job_hash = Hash[days.map { |day| [day.to_s, 0] }]
    total_base_user_hash = Hash[days.map { |day| [day.to_s, 0] }]
    total_kol_hash = Hash[days.map { |day| [day.to_s, 0] }]
    total_report_hash = Hash[days.map { |day| [day.to_s, 0] }]
    if ['half_year', 'year'].include?(tab)
      total_job.each do |object|
        total_job_hash[object.month.to_date.to_s] = object.count
      end
      total_base_user.each do |object|
        total_base_user_hash[object.month.to_date.to_s] = object.count
      end
      total_kol.each do |object|
        total_kol_hash[object.month.to_date.to_s] = object.count
      end
      total_report.each do |object|
        total_report_hash[object.month.to_date.to_s] = object.count
      end

    else
      total_job.each do |date, count|
        total_job_hash[date.to_s] = count
      end
      total_base_user.each do |date, count|
        total_base_user_hash[date.to_s] = count
      end
      total_kol.each do |date, count|
        total_kol_hash[date.to_s] = count
      end
      total_report.each do |date, count|
        total_report_hash[date.to_s] = count
      end
    end

    render json: {
      data: {
        label: total_job_hash.keys,
        total_job: total_job_hash.values,
        total_base_user: total_base_user_hash.values,
        total_kol: total_kol_hash.values,
        total_report: total_report_hash.values
      }
    }, status: 200
  end

  private

  def get_months_in_year(year)
    months = []
    (1..12).each do |month|
      months << Date.new(year, month, 1)
    end
    months
  end

  def get_last_6_months
    today = Date.today
    months = []

    6.downto(0) do |i|
      month = today.month - i
      year = today.year
      if month <= 0
        month += 12
        year -= 1
      end
      months << Date.new(year, month, 1)
    end

    months
  end
end
