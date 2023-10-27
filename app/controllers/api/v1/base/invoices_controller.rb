class Api::V1::Base::InvoicesController < Api::V1::Base::BaseController
  before_action :prepare_invoice, only: %i[show]

  def index
    search = params[:search]
    tab = params[:tab]
    jobs = policy_scope([:base, Job]).order(created_at: :desc)
    if search.present?
      jobs = jobs.where('title LIKE ?', "%#{search}%")
    end
    if tab.present? && tab != 'all'
      jobs = jobs.where(status: tab).order(created_at: :desc)
    end
    pagy, jobs = pagy(jobs, page: page_number, items: page_size)
    render json: JobSerializer.new(jobs, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    render json: JobSerializer.new(@invoice), status: 200
  end

  private

  def prepare_invoice
    @invoice = Job.find_by(id: params[:id])
  end
end
