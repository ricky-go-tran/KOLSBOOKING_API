class Api::V1::Base::InvoicesController < Api::V1::Base::BaseController
  include ConstantHelper
  before_action :prepare_invoice, only: %i[show]

  def index
    search = params[:search]
    tab = params[:tab]
    jobs = policy_scope([:base, Job]).order(created_at: :desc)
    jobs = jobs.search_by_title(search) if search.present?
    jobs = jobs.where(status: tab).order(created_at: :desc) if tab.present? && JOBS_ACCEPTED_PARAMS.include?(tab)
    pagy, jobs = pagy(jobs, page: page_number, items: page_size)
    render json: JobSerializer.new(jobs, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    authorize @invoice, policy_class: Base::InvoicePolicy
    render json: JobSerializer.new(@invoice), status: 200
  end

  private

  def prepare_invoice
    @invoice = Job.find_by(id: params[:id])
  end
end
