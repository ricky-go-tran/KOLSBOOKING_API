FactoryBot.define do
  factory :bussiness do
    type_profile { 'bussiness' }
    overview { Faker::Lorem.sentence }
  end
end
