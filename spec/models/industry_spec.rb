# == Schema Information
#
# Table name: industries
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Industry, type: :model do
  describe 'association' do
    it { should have_many(:industry_associations) }
  end
end
