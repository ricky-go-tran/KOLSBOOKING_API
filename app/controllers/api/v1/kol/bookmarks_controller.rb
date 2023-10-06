class Api::V1::Kol::BookmarksController < Api::V1::Kol::BaseController
  before_action :prepare_bookmark, only: %i[mark unmark]

  def index
    bookmarks = if params[:tab].nil? || params[:tab] == 'all'
                  policy_scope([:kol, Bookmark]).order(created_at: :desc)
                else
                  policy_scope([:kol, Bookmark]).where(status: params[:tab]).order(created_at: :desc)
                end
    pagy, bookmarks = pagy(bookmarks, page: page_number, items: page_size)
    render json: BookmarkSerializer.new(bookmarks, { meta: pagy_metadata(pagy) }), status: 200
  end

  def mark
    if @bookmark.blank?
      new_bookmark = Bookmark.new(bookmark_params)
      new_bookmark.kol_profile_id = current_user.profile.kol_profile.id
      if new_bookmark.save
        render json: BookmarkSerializer.new(new_bookmark), status: 201
      else
        render json: { errors: new_bookmark.errors.full_messages }, status: 422
      end
    elsif @bookmark.status != bookmark_params[:status]
      authorize @bookmark, policy_class: Kol::BookmarkPolicy
      if @bookmark.update(bookmark_params)
        render json: BookmarkSerializer.new(@bookmark), status: 200
      else
        render json: { errors: @bookmark.errors.full_messages }, status: 422
      end
    else
      render json: { errors: [I18n.t('bookmark.error.already')] }, status: 422
    end
  end

  def unmark
    if @bookmark.blank?
      render json: { errors: [I18n.t('bookmark.error.no_exist')] }, status: 422
    else
      authorize @bookmark, policy_class: Kol::BookmarkPolicy
      if @bookmark.destroy
        render json: { message: I18n.t('bookmark.success.deleted') }, status: 200
      else
        render json: { errors: @bookmark.errors.full_messages }, status: 422
      end
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:job_id, :status)
  end

  def prepare_bookmark
    @bookmark = Bookmark.find_by(kol_profile_id: current_user.profile.kol_profile.id, job_id: params[:id])
  end
end
