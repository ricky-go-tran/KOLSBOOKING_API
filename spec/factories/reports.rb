FactoryBot.define do
  factory :report do
    title { 'MyString' }
    description { 'MyText' }
    objective { nil }
    user { nil }
  end
end
