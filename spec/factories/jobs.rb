FactoryBot.define do
  factory :job do
    title { 'MyString' }
    description { 'MyText' }
    price { 1.5 }
    status { 'MyString' }
    stripe_id { 'MyString' }
  end
end
