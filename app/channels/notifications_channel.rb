class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_for "notifications_#{params[:profile_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
