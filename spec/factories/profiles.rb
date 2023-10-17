# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  fullname   :string           not null
#  birthday   :date
#  phone      :string
#  address    :text
#  status     :string           default("valid")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  avatar_url :string
#  uid        :string
#  provider   :string
#  stripe_id  :string           default("none"), not null
#
FactoryBot.define do
  factory :profile do
    fullname { Faker::Lorem.characters(number: rand(4..20)) }
    birthday { Faker::Date.birthday(min_age: 18, max_age: 65) }
    phone { '0123456789' }
    address { Faker::Address.full_address }
  end
end
