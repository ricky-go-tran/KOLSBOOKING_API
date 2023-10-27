class Api::V1::Base::StatisticalController < Api::V1::Base::BaseController
  def index
    tab = params[:tab]
    filter = extract_filter(tab, params[:filter])
    data = calculate_statistics(tab, current_user.profile.id, filter)
    render json: build_statistics_response(data), status: 200
  end

  private

  def generate_date(days)
    Hash[days.map { |day| [day.to_s, 0] }]
  end

  def extract_filter(tab, filter_param)
    case tab
    when 'year' then filter_param.to_i
    when 'month' then filter_param.split('-').map(&:to_i)
    end
  end

  def calculate_statistics(tab, profile_id, filter)
    data_hash = {}
    data = StatisticalBaseByTimeService.call(tab, profile_id, filter)
    data_hash[:total_job] = generate_date(data[:days])
    data_hash[:cancle_job] = generate_date(data[:days])
    data_hash[:finish_job] = generate_date(data[:days])
    FetchStatisticalKolService.call(data, data_hash, tab)
  end

  def build_statistics_response(data)
    {
      label: data[:total_job].keys,
      total_job: data[:total_job].values,
      cancle_job: data[:cancle_job].values,
      finish_job: data[:finish_job].values
    }
  end
end
