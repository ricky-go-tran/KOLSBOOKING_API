class Api::V1::ReviewsController < ApplicationController
  def index
    reviews = policy_scope(Review).order(created_at: :desc)
    pagy, reviews = pagy(reviews, page: page_number, items: page_size)
    render json: ReviewWithReviewerProfileSerializer.new(reviews, { meta: pagy_metadata(pagy) }), status: 200
  end

  def reviews_by_reviewed
    reviews = Review.where(reviewed: params[:id]).order(created_at: :desc)
    pagy, reviews = pagy(reviews, page: page_number, items: page_size)
    render json: ReviewWithReviewerProfileSerializer.new(reviews, { meta: pagy_metadata(pagy) }), status: 200
  end

  def create
    review = Review.new(review_params)
    if review.save
      render json: { status: 'Review create success' }, status: 201
    else
      render json: { errors: review.errors.full_messages }, status: 422
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :reviewer_id, :reviewed_id)
  end
end
