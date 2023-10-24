class Api::V1::Base::FollowersController < ApplicationController
  before_action :prepare_follower, only: %i[unfollow]

  def index
    follows = policy_scope([:base, Follower])
    pagy, follows = pagy(follows, page: page_number, items: page_size)
    render json: FollowSerializer.new(follows, { meta: pagy }), status: 200
  end

  def follow
    follower = Follower.new(follower_params)
    if follower.save
      render json: FollowSerializer.new(follower), status: 201
    else
      render json: { errors: ['Follow failed'] }, status: 422
    end
  end

  def unfollow
    if @follower.destroy
      render json: { message: 'Unfollow successfully' }, status: 200
    else
      render json: { errors: ['Follow failed'] }, status: 422
    end
  end

  private

  def prepare_follower
    @follower = Follower.find_by(followed_id: params[:id], follower_id: current_user.profile.id)
  end

  def follower_params
    params.require(:follower).permit(:follower_id, :followed_id)
  end
end
