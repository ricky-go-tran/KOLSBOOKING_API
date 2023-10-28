class NotificationChannel < ApplicationCable::Channel
  def subscribed
    # stop_all_streams
    # profile = Profile.find(params[:id])
    # stream_for profile
    stream_for 'notification_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
