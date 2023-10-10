require 'rails_helper'

RSpec.describe KolProfile, type: :model do
  describe 'association' do
    it { should belong_to(:profile) }
    it { should have_many(:bookmarks) }
    it { should have_many(:tasks) }
    it { should have_many(:industry_associations) }
    it { should accept_nested_attributes_for(:industry_associations).allow_destroy(true) }
  end
end
