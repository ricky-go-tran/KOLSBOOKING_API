# == Schema Information
#
# Table name: jobs
#
#  id          :bigint           not null, primary key
#  profile_id  :bigint           not null
#  kol_id      :bigint           not null
#  title       :string           not null
#  description :text
#  price       :float            not null
#  status      :string           default("post"), not null
#  stripe_id   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  requirement :text             default("Requirement content"), not null
#
FactoryBot.define do
  factory :job do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph(sentence_count: 4) }
    requirement { Faker::Lorem.paragraph(sentence_count: 4) }
    price { Faker::Number.within(range: 1..5) }
    status { 'post' }
    stripe_id { nil }
  end
end
