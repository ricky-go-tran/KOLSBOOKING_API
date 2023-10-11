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
FactoryBot.define do
  factory :task do
    title { 'MyString' }
    start_time { '2023-09-06 14:20:41' }
    end_time { '2023-09-06 14:20:41' }
    status { 'MyString' }
    description { 'MyText' }
  end
end
