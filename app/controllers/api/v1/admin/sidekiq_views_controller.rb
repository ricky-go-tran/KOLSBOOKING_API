class Api::V1::Admin::SidekiqViewsController < Api::V1::Admin::BaseController
  def index
    stats = Sidekiq::Stats::History.new(30)
    render json: { labeled: stats.processed.keys, proccessed: stats.processed.values, failed: stats.failed.values }, status: 200
  end
end
