# == Schema Information
#
# Table name: industries
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :industry do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph(sentence_count: 4) }
  end
end
