class Api::V1::Base::PaymentIntentsController < ApplicationController
  def create
    payment_intent = Stripe::PaymentIntent.create(
      amount: params[:amount].to_i,
      currency: params[:currency],
      description: params[:desciption]
    )
    render json: {
      id: payment_intent.id,
      client_secret: payment_intent.client_secret
    }, status: 200
  end

  def retrieve
    payment_intent = Stripe::PaymentIntent.retrieve(
      params[:id]
    )
    render json: {
      id: payment_intent.id,
      client_secret: payment_intent.client_secret
    }
  end

  def update_job
    @job = Job.find_by(id: params[:job_id])
    @job.stripe_id = params[:stripe_payment_id]
    if @job.save
      render json: {
        message: 'success'
      }, status: 200
    else
      render json: {
        status: 'fail'
      }, status: 422
    end
  end
end
