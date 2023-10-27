module EmojiHandling
  extend ActiveSupport::Concern

  included do
    before_action :check_authentication
    before_action :prepare_emoji, only: [:like, :unlike, :destroy]
  end

  def index
    emojis = Emoji.includes([:profile, :emojiable])
      .where(profile_id: current_user.profile.id, emojiable_type:)
      .order(created_at: :desc)
    pagy, emojis = pagy(emojis, page: page_number, items: page_size)
    render json: EmojiWithObjectSerializer.new(emojis, meta: pagy_metadata(pagy)), status: :ok
  end

  def like
    handle_emoji('like', 'Like is success')
  end

  def unlike
    handle_emoji('unlike', 'Unlike is success')
  end

  def destroy
    if @emoji.destroy
      render json: { message: 'Delete this emoji' }, status: :ok
    else
      render json: { errors: @emoji.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def prepare_emoji
    @emoji = Emoji.find_by(emojiable_type:, emojiable_id: params[:id], profile_id: current_user.profile.id)
  end

  def emojiable_type; end

  def handle_emoji(status, success_message)
    if @emoji.blank?
      new_emoji = Emoji.new(
        profile_id: current_user.profile.id,
        status:,
        emojiable_type:,
        emojiable_id: params[:id]
      )
      if new_emoji.save
        render json: { message: success_message }, status: :created
      else
        render json: { errors: new_emoji.errors.full_messages }, status: :unprocessable_entity
      end
    elsif @emoji.status != status
      if @emoji.update(status:)
        render json: { message: success_message }, status: :ok
      else
        render json: { errors: @emoji.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "You already #{status} this emoji" }, status: 204
    end
  end
end
