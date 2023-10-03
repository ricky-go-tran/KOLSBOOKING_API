class IndustryAssociation < ApplicationRecord
  belongs_to :industry
  belongs_to :insdustry_associationable, polymorphic: true, inverse_of: :insdustry_associationable
end
