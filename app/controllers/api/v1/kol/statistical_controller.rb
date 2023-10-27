class Api::V1::Kol::StatisticalController < Api::V1::Kol::BaseController
  def index
    tab = params[:tab]
    filter = extract_filter(tab, params[:filter])
    data_hash = calculate_statistics(tab, current_user.profile.id, filter)
    render json: build_statistics_response(data_hash), status: 200
  end

  private

  def extract_filter(tab, filter_param)
    case tab
    when 'year' then filter_param.to_i
    when 'month' then filter_param.split('-').map(&:to_i)
    end
  end

  def calculate_statistics(tab, kol_current_id, filter)
    data_hash = {}
    data = StatisticalKolByTimeService.call(tab, kol_current_id, filter)
    data_hash[:total_job] = generate_date(data[:days])
    data_hash[:cancle_job] = generate_date(data[:days])
    data_hash[:finish_job] = generate_date(data[:days])
    FetchStatisticalKolService.call(data, data_hash, tab)
  end

  def generate_date(days)
    Hash[days.map { |day| [day.to_s, 0] }]
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
