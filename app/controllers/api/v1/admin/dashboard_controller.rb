class Api::V1::Admin::DashboardController < Api::V1::Admin::BaseController
  include DashboardHelpers

  def index
    tab = params[:tab]
    filter = fetch_filter(tab, params[:filter])
    data = fetch_data(tab, filter)
    data_hash = generate_data_hash(data, tab)
    render_json_response(data_hash)
  end

  private

  def render_json_response(data_hash)
    render json: {
      data: {
        label: data_hash[:total_job_hash].keys,
        total_job: data_hash[:total_job_hash].values,
        total_base_user: data_hash[:total_base_user_hash].values,
        total_kol: data_hash[:total_kol_hash].values,
        total_report: data_hash[:total_report_hash].values
      }
    }, status: :ok
  end
end
