class Api::V1::Admin::ReportsController < ApplicationController
  before_action :prepare_job, only: %i[proccess sovled rejected]

  def index
    @reports = Report.preload(:profile).all
    render json: ReportSerializer.new(@reports), status: 200
  end

  def proccess
    if @report.status != 'pending'
      render json: { errors: [I18n.t('report.error.must_pending')] }, status: 422
    elsif @report.update(status: 'proccess')
      render json: ReportSerializer.new(@report), status: 200
    else
      render json: { errors: @report.errors.full_messages }, status: 422
    end
  end

  def sovled
    if @report.status != 'proccess'
      render json: { errors: [I18n.t('report.error.must_proccess')] }, status: 422
    elsif @report.update(status: 'sovled')
      render json: ReportSerializer.new(@report), status: 200
    else
      render json: { errors: @report.errors.full_messages }, status: 422
    end
  end

  def rejected
    if @report.status != 'proccess'
      render json: { errors: [I18n.t('report.error.must_proccess')] }, status: 422
    elsif @report.update(status: 'rejected')
      render json: ReportSerializer.new(@report), status: 200
    else
      render json: { errors: @report.errors.full_messages }, status: 422
    end
  end

  private

  def prepare_report
    @report = Report.find_by(id: params[:id])
  end
end