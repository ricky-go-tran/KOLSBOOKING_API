# == Schema Information
#
# Table name: industry_associations
#
#  id                             :bigint           not null, primary key
#  industry_id                    :bigint           not null
#  insdustry_associationable_type :string           not null
#  insdustry_associationable_id   :bigint           not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
FactoryBot.define do
  factory :industry_association do
  end
end
