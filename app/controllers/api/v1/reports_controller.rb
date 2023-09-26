class Api::V1::ReportsController < ApplicationController
  def create
    report = Report.new(report_params)
    if report.save
      render json: ReportSerializer(report), status: :created
    else
      render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def report_params
    params.require(:report).permit(:title, :description, :reportable_type, :reportable_id, :profile_id)
  end
end
