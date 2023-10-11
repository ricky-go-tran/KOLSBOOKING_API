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
class IndustryAssociationSerializer < BaseSerializer
  attributes :id, :industry_id, :insdustry_associationable_type, :insdustry_associationable_id, :created_at
end
