class Api::V1::EmojiJobsController < ApplicationController
  before_action :check_authentication

  def like
    @emoji = prepare_emoji
    if @emoji.blank?
      new_emoji = Emoji.new
      new_emoji.profile_id = current_user.profile.id
      new_emoji.status = 'like'
      new_emoji.emojiable_type = 'Job'
      new_emoji.emojiable_id = params[:id]
      if new_emoji.save
        render json: { message: 'Like is success' }, status: 201
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
      render json: { message: 'You already like this emoji' }, status: 204
    end
  end

  def unlike
    @emoji = prepare_emoji
    if @emoji.blank?
      new_emoji = Emoji.new
      new_emoji.profile_id = current_user.profile.id
      new_emoji.status = 'unlike'
      new_emoji.emojiable_type = 'Job'
      new_emoji.emojiable_id = params[:id]
      if new_emoji.save
        render json: { message: 'Unlike is success' }, status: 201
      else
        render json: { errors: new_emoji.errors.full_messages }, status: :unprocess_entity
      end
    elsif @emoji.status != 'unlike'
      if @emoji.update(status: 'unlike')
        render json: { message: 'Unlike is success' }, status: 200
      else
        render json: { errors: @emoji.errors.full_messages }, status: :unprocess_entity
      end
    else
      render json: { message: 'You already like this emoji' }, status: 204
    end
  end

  private

  def prepare_emoji
    Emoji.find_by(emojiable_type: 'Job', emojiable_id: params[:id], profile_id: current_user.profile.id)
  end
end