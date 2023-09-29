class Api::V1::KolsController < ApplicationController
  before_action :prepare_kol, only: %i[show]

  def index
    kols = User.with_role(:kol).joins(:profile).where("profiles.status = 'valid'")
    pagy, kols = pagy(kols, page: page_number, items: page_size)
    render json: UserSerializer.new(kols, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    check_present_record(@kol)
    authorize @kol, policy_class: KolPolicy
    render json: KolByProfileSerializer.new(@kol), statu: 200
  end

  private

  def prepare_kol
    @kol = Profile.find_by(id: params[:id])
  end
end
