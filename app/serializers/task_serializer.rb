# == Schema Information
#
# Table name: tasks
#
#  id             :bigint           not null, primary key
#  kol_profile_id :bigint           not null
#  title          :string           not null
#  start_time     :datetime         not null
#  end_time       :datetime         not null
#  status         :string           default("planning"), not null
#  description    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category       :string           default("personal"), not null
#
class TaskSerializer < BaseSerializer
  attributes :id, :title, :start_time, :end_time, :status, :description, :category
end
