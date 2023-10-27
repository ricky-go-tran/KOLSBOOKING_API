class Api::V1::KolsController < ApplicationController
  before_action :prepare_kol, only: %i[show]

  def index
    search = params[:search]
    filter = params[:filter]
    kols = User.with_role(:kol).includes(profile: [:followed, :follower, { avatar_attachment: :blob }]).joins(:profile).where("profiles.status = 'valid'")
    if search.present?
      kols = kols.where('profiles.fullname LIKE ?', "'#{search}'")
    end
    if filter.present?
      unless filter_follower_empty?(filter)
        kols = kols.filter_follow(filter)
      end

      unless filter_like_empty?(filter)
        kols = kols.filter_like(filter)
      end

      unless filter_industry_empty?(filter)
        kols = kols.filter_industry(filter)
      end
    end
    pagy, kols = pagy(kols, page: page_number, items: page_size)
    render json: KolByUserSerializer.new(kols, { meta: pagy_metadata(pagy) }), status: 200
  end

  def show
    check_present_record(@kol)
    authorize @kol, policy_class: KolPolicy
    if current_user.blank?
      render json: KolByProfileDetailSerializer.new(@kol), status: 200
    elsif current_user.has_role?(:base)
      profile_id = current_user.profile.id
      render json: KolByProfileDetailWithCurrentEmojiAndFollowSerializer.new(@kol, { params: { profile_id: } }), status: 200
    else
      profile_id = current_user.profile.id
      render json: KolByProfileDetailWithCurrentUserEmojiSerializer.new(@kol, { params: { profile_id: } }), status: 200
    end
  end

  private

  def prepare_kol
    @kol = Profile.find_by(id: params[:id])
  end

  def filter_follower_empty?(filter)
    filter.nil? || (filter[:follow][:min].to_i == filter[:follow][:max].to_i && filter[:follow][:max].to_i.zero?)
  end

  def filter_like_empty?(filter)
    filter.nil? || (filter[:like][:min].to_i == filter[:like][:max].to_i && filter[:like][:max].to_i.zero?)
  end

  def filter_industry_empty?(filter)
    filter[:industry].nil?
  end
end
