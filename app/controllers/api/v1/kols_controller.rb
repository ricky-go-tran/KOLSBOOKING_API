class Api::V1::KolsController < ApplicationController
  include FilterKolsGeneral

  before_action :prepare_kol, only: %i[show]

  def index
    search = params[:search]
    filter = params[:filter]
    kols = User.get_all_kols_valid
    kols = kols.search_kols_by_fullname(search) if search.present?
    kols = apply_filters(kols, filter) if filter.present?
    pagy, kols = pagy(kols, page: page_number, items: page_size)
    render json: KolByUserSerializer.new(kols, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    check_present_record(@kol)
    authorize @kol, policy_class: KolPolicy
    serializer = select_serializer
    if current_user.blank?
      render json: serializer.new(@kol), status: 200
    else
      render json: serializer.new(@kol,  { params: { profile_id: current_user.profile.id } }), status: 200
    end
  end

  private

  def prepare_kol
    @kol = Profile.find_by(id: params[:id])
  end

  def select_serializer
    if current_user.blank?
      KolByProfileDetailSerializer
    else
      KolByProfileDetailWithCurrentEmojiAndFollowSerializer
    end
  end
end
