require 'rails_helper'

RSpec.describe Industry, type: :model do
  describe 'association' do
    it { should have_many(:industry_associations) }
  end
end
