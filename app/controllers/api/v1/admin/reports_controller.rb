class Api::V1::Admin::ReportsController < ApplicationController
  before_action :prepare_report, only: %i[proccess sovled rejected show]

  def index
    search = params[:search]
    tab = params[:tab]
    reports = Report.all.includes(profile: [:user, { avatar_attachment: :blob }, :google_integrate]).order(created_at: :desc)
    if search.present?
      reports = reports.where('title LIKE ?', "%#{search}%")
    end
    if tab.present? && tab != 'all'
      reports = reports.where(status: params[:tab]).order(created_at: :desc)
    end
    pagy, reports = pagy(reports, page: page_number, items: page_size)
    render json: ReportSerializer.new(reports, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    render json: ReportSerializer.new(@report), status: 200
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
