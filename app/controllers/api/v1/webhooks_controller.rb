class Api::V1::WebhooksController < ApplicationController
  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil
    endpoint_secret = Rails.application.credentials.webhook_key
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      render json: { message: 'ParserError', data: e.message }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { message: 'SignatureVerificationError', data: e.message }, status: 400
      return
    end

    case event.type
    when 'charge.succeeded'
      payment_intent = event.data.object
      @job = Job.find_by(stripe_id: payment_intent.payment_intent)
      @job.update(status: 'finish')
      @profile = @job.profile
      if @job.save
        if Notification.create(title: "#{@profile.fullname} has been payment at #{Time.current.strftime('%a %b %d %Y')}", description: "#{@profile.fullname} has been payment to job name #{@job.title}", sender_id: @job.profile_id, receiver_id: @job.kol_id)
          NotificationsChannel.broadcast_to("notifications_#{@job.kol_id}", 'Sending..')
        end
      else
        render json: { errors: 'Server Interval Error' }, status: 422
      end
    else
      puts 'Hello'
      render json: { errors: 'Payment Fails' }
    end
  end
end
