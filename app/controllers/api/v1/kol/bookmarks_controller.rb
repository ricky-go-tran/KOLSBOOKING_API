class Api::V1::Kol::BookmarksController < Api::V1::Kol::BaseController
  before_action :prepare_bookmark, only: %i[mark unmark]

  def index
    bookmarks = fetch_filtered_bookmarks
    pagy, bookmarks = pagy(bookmarks, page: page_number, items: page_size)
    render json: BookmarkSerializer.new(bookmarks, { meta: pagy_metadata(pagy) }), status: 200
  end

  def mark
    authorize @bookmark, policy_class: Kol::BookmarkPolicy
    if @bookmark.blank?
      create_new_bookmark
    elsif @bookmark.status != bookmark_params[:status]
      update_existing_bookmark
    else
      render json: { errors: [I18n.t('bookmark.error.already')] }, status: 422
    end
  end

  def unmark
    if @bookmark.blank?
      render json: { errors: [I18n.t('bookmark.error.no_exist')] }, status: 422
    else
      authorize @bookmark, policy_class: Kol::BookmarkPolicy
      authorize_and_destroy_bookmark
    end
  end

  private

  def fetch_filtered_bookmarks
    bookmarks = policy_scope([:kol, Bookmark])
    bookmarks = filter_bookmarks_by_status(bookmarks, params[:tab]) if params[:tab].present?
    bookmarks.order(created_at: :desc)
  end

  def filter_bookmarks_by_status(bookmarks, status)
    status == 'all' ? bookmarks : bookmarks.where(status:)
  end

  def create_new_bookmark
    new_bookmark = Bookmark.new(bookmark_params)
    new_bookmark.kol_profile_id = current_user.profile.kol_profile.id
    if new_bookmark.save
      render json: BookmarkSerializer.new(new_bookmark), status: 201
    else
      render json: { errors: new_bookmark.errors.full_messages }, status: 422
    end
  end

  def update_existing_bookmark
    if @bookmark.update(bookmark_params)
      render json: BookmarkSerializer.new(@bookmark), status: 200
    else
      render json: { errors: @bookmark.errors.full_messages }, status: 422
    end
  end

  def authorize_and_destroy_bookmark
    if @bookmark.destroy
      render json: { message: I18n.t('bookmark.success.deleted') }, status: 200
    else
      render json: { errors: @bookmark.errors.full_messages }, status: 422
    end
  end

  def bookmark_params
    params.require(:bookmark).permit(:job_id, :status)
  end

  def prepare_bookmark
    @bookmark = Bookmark.find_by(kol_profile_id: current_user.profile.kol_profile.id, job_id: params[:id])
  end
end
