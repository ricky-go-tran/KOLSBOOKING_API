class Api::V1::Admin::ReportsController < Api::V1::Admin::BaseController
  before_action :prepare_report, only: %i[proccess sovled rejected show]

  def index
    search = params[:search]
    tab = params[:tab]
    reports = Report.all.includes(profile: [:user, { avatar_attachment: :blob }, :google_integrate]).order(created_at: :desc)
    reports = reports.search_by_title if search.present?
    reports = reports.where(status: params[:tab]).order(created_at: :desc) if tab.present? && tab != 'all'
    pagy, reports = pagy(reports, page: page_number, items: page_size)
    render json: ReportSerializer.new(reports, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    render json: ReportSerializer.new(@report), status: 200
  end

  def proccess
    update_report_status('process', 'pending')
  end

  def sovled
    update_report_status('solve', 'process')
  end

  def rejected
    update_report_status('reject', 'process')
  end

  private

  def prepare_report
    @report = Report.find_by(id: params[:id])
  end

  def update_report_status(action, required_status)
    if @report.status != required_status
      render json: { errors: [I18n.t("report.error.must_#{required_status}")] }, status: :unprocessable_entity
    elsif @report.update(status: action)
      render json: ReportSerializer.new(@report), status: :ok
    else
      render json: { errors: @report.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
