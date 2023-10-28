module DashboardHelpers
  extend ActiveSupport::Concern

  private

  def fetch_filter(tab, param)
    if tab == 'year'
      param.to_i
    elsif tab == 'month'
      param.split('-').map(&:to_i)
    end
  end

  def fetch_data(tab, filter)
    case tab
    when 'month'
      StatisticalAdminByMonthService.call(filter)
    when 'half_year'
      StatisticalAdminByHalfYearService.call
    when 'year'
      StatisticalAdminByYearService.call(filter)
    else
      {}
    end
  end

  def generate_data_hash(data, tab)
    data_hash = GenerateHashDataStatisticalAdminService.call(data)
    if ['half_year', 'year'].include?(tab)
      FetchStatisticalAdminByYearToHashService.call(data, data_hash)
    else
      FetchStatisticalAdminByMonthToHashService.call(data, data_hash)
    end
    data_hash
  end
end
