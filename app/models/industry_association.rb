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
class IndustryAssociation < ApplicationRecord
  belongs_to :industry
  belongs_to :insdustry_associationable, polymorphic: true, inverse_of: :insdustry_associationable
end
