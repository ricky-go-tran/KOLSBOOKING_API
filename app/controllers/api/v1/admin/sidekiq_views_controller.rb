class Api::V1::Admin::SidekiqViewsController < Api::V1::Admin::BaseController
  def get_job_current_moth
    stats = Sidekiq::Stats::History.new(30)
    render json: { proccessed: stats.processed, failed: stats.failed }, status: 200
  end
end
