class Api::V1::NotificationsController < ApplicationController
  before_action :check_authentication
  before_action :prepare_notification, only: %i[read]
  def index
    notifications = policy_scope(Notification).order(created_at: :desc)
    render json: NotificationSerializer.new(notifications), status: :ok
  end

  def create
    notification = Notification.new(notification_params)
    if notification.save
      broadcast_notification(notification)
      render json: { message: 'Successfully marked' }, status: :created
    else
      render json: { errors: notification.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def read
    if mark_notification_as_read
      render json: NotificationSerializer.new(@notification), status: :ok
    else
      render json: { errors: @notification.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:title, :description, :type_notice, :sender_id, :receiver_id)
  end

  def prepare_notification
    @notification = Notification.find_by(id: params[:id])
  end

  def broadcast_notification(notification)
    NotificationsChannel.broadcast_to("notifications_#{notification.receiver_id}", 'Sending..')
  end

  def mark_notification_as_read
    @notification.update(is_read: true)
  end
end
