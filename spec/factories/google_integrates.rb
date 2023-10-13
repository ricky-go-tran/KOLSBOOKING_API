# == Schema Information
#
# Table name: google_integrates
#
#  id                 :bigint           not null, primary key
#  profile_id         :bigint           not null
#  gmail              :string
#  refresh_token      :string
#  access_token       :string
#  code_authorization :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :google_integrate do
    refresh_token { "MyString" }
    access_token { "MyString" }
    code_authorization { "MyString" }
  end
end
