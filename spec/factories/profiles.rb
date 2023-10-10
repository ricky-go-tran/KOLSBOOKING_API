FactoryBot.define do
  factory :profile do
    fullname { 'MyString' }
    birthday { '2000-09-06' }
    phone { '0123456789' }
    address { 'MyText' }
  end
end
