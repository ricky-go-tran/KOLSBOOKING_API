# == Schema Information
#
# Table name: reports
#
#  id              :bigint           not null, primary key
#  title           :string           not null
#  description     :text             not null
#  reportable_type :string           not null
#  reportable_id   :bigint           not null
#  profile_id      :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :string           default("pending")
#
FactoryBot.define do
  factory :report do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph(sentence_count: 4) }
  end
end
