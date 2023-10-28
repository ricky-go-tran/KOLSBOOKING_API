class Api::V1::ReportsController < ApplicationController
  before_action :check_authentication
  before_action :prepare_report, only: %i[destroy update]

  def create
    report = Report.new(report_params)
    if report.save
      render json: ReportSerializer.new(report), status: :created
    else
      render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
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
