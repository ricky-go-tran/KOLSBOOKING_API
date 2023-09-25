class Api::V1::EmojisController < ApplicationController
  before_action :prepare_emoji, only: %i[like unlike]

  def like
    if @emoji.blank?
      new_emoji = Emoji.new(emoji_params)
      if new_emoji.save
        render json: { message: 'Like is success' }, status: :create
      else
        render json: { errors: new_emoji.errors.full_messages }, status: :unprocess_entity
      end
    elsif @emoji.status != 'like'
      if @emoji.update(status: 'like')
        render json: { message: 'Like is success' }, status: 200
      else
        render json: { errors: @emoji.errors.full_messages }, status: :unprocess_entity
      end
    else
      render json: { message: 'You already like this emoji' }, status: 303
    end
  end

  def unlike
    if @emoji.blank?
      new_emoji = Emoji.new(emoji_params)
      if new_emoji.save
        render json: { message: 'Like is success' }, status: :create
      else
        render json: { errors: new_emoji.errors.full_messages }, status: :unprocess_entity
      end
    elsif @emoji.status != 'like'
      if @emoji.update(status: 'like')
        render json: { message: 'Like is success' }, status: 200
      else
        render json: { errors: @emoji.errors.full_messages }, status: :unprocess_entity
      end
    else
      render json: { message: 'You already like this emoji' }, status: 303
    end
  end

  private

  def prepare_emoji
    @emoji = Emoji.find_by(id: params[:id])
  end

  def emoji_params
    params.require(:emoji).permit(:status, :emojiable_type, :emojiable_id, :profile_id)
  end
end
