class Api::V1::ReportsController < ApplicationController
  before_action :check_authentication
  before_action :prepare_report, only: %i[destroy update]

  def index
    reports = Report.policy_scope(Report)
    pagy, reports = pagy(reports, page: page_number, items: page_size)
    render json: ReportSerializer.new(reports, { meta: pagy_metadata(pagy) }), status: 200
  end

  def create
    report = Report.new(report_params)
    if report.save
      render json: ReportSerializer.new(report), status: :created
    else
      render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @report, policy_class: ReportPolicy
    if @report.destroy
      render json: { message: 'Report has been destroyed' }, status: 200
    else
      render json: { errors: @report.errors.full_messages }, status: 422
    end
  end

  def update
    authorize @report, policy_class: ReportPolicy
    if @report.update(report_params)
      render json: ReportSerializer.new(@report), status: 200
    else
      render json: { errors: @report.errors.full_messages }, status: 422
    end
  end

  private

  def report_params
    params.require(:report).permit(:title, :description, :reportable_type, :reportable_id, :profile_id)
  end

  def prepare_report
    @report = Report.find_by(id: params[:id])
  end
end
