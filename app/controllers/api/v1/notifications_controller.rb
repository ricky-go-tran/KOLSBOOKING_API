class Api::V1::NotificationsController < ApplicationController
  before_action :check_authentication
  before_action :prepare_notification, only: %i[read]

  def index
    notifications = policy_scope(Notification).order(created_at: :desc)
    render json: NotificationSerializer.new(notifications), status: 200
  end

  def create
    notification = Notification.new(notification_param)
    if notification.save
      NotificationsChannel.broadcast_to("notifications_#{notification_param[:receiver_id]}", 'Sending..')
      render json: { message: 'Successfully marked' }, status: 201
        .else
      render json: { errors: notification.errors.full_messages }, status: 422
    end
  end

  def read
    @notification.is_read = true
    if @notification.save
      render json: NotificationSerializer.new(@notification), status: 200
    else
      render json: { errors: notification.errors.full_messages }, status: 422
    end
  end

  private

  def notification_param
    params.require(:notification).permit(:title, :description, :type_notice, :sender_id, :receiver_id)
  end

  def prepare_notification
    @notification = Notification.find_by(id: params[:id])
  end
end
