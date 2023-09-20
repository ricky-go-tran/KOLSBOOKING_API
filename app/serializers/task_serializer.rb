class TaskSerializer < BaseSerializer
  attributes :id, :title, :start_time, :end_time, :status, :description
end
