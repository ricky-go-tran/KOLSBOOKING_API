require 'rails_helper'

RSpec.describe IndustryAssociation, type: :model do
  describe 'association' do
    it { should belong_to(:industry) }
    it 'is polymorphic' do
     expect(IndustryAssociation.reflect_on_association(:insdustry_associationable).options[:polymorphic]).to be true
    end
    it 'has an inverse_of' do
      association = IndustryAssociation.new
      expect(association).to belong_to(:insdustry_associationable).inverse_of(:insdustry_associationable)
    end
  end
end
