class Api::V1::Kol::StatisticalController < Api::V1::Kol::BaseController
  def index
    tab = params[:tab]
    filter = nil
    if tab == 'year'
      filter = params[:filter].to_i
    elsif tab == 'month'
      filter = params[:filter].split('-').map(&:to_i)
    end
    data_hash = {}
    kol_current_id = current_user.profile.id
    data = StatisticalKolByTimeService.call(tab, kol_current_id, filter)
    data_hash[:total_job] = generate_date(data[:days])
    data_hash[:cancle_job] = generate_date(data[:days])
    data_hash[:finish_job] = generate_date(data[:days])

    data_hash = FetchStatisticalKolService.call(data, data_hash, tab)
    render json: {
      label: data_hash[:total_job].keys,
      total_job: data_hash[:total_job].values,
      cancle_job: data_hash[:cancle_job].values,
      finish_job: data_hash[:finish_job].values
    }, status: 200
  end

  private

  def generate_date(days)
    Hash[days.map { |day| [day.to_s, 0] }]
  end
end
