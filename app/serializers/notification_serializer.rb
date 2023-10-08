class NotificationSerializer < BaseSerializer
  attributes :id, :title, :description, :type_notice, :sender_id, :receiver_id, :is_read
end
