class Api::V1::Admin::DashboardController < ApplicationController
  def index
    tab = params[:tab]
    data = {}
    if tab.blank? || tab == 'month'
      data = StatisticalAdminByMonthService.call
    elsif tab == 'half_year'
      data = StatisticalAdminByHalfYearService.call
    elsif tab == 'year'
      data = StatisticalAdminByYearService.call
    end
    data_hash = GenerateHashDataStatisticalAdminService.call(data)
    data_hash = if ['half_year', 'year'].include?(tab)
                  FetchStatisticalAdminByYearToHashService.call(data, data_hash)
                else
                  FetchStatisticalAdminByMonthToHashService.call(data, data_hash)
                end
    render json: {
      data: {
        label: data_hash[:total_job_hash].keys,
        total_job: data_hash[:total_job_hash].values,
        total_base_user: data_hash[:total_base_user_hash].values,
        total_kol: data_hash[:total_kol_hash].values,
        total_report: data_hash[:total_report_hash].values
      }
    }, status: 200
  end
end
