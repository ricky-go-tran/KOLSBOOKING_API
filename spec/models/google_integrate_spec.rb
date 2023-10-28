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
require 'rails_helper'

RSpec.describe GoogleIntegrate, type: :model do
  describe 'association' do
    it { should belong_to(:profile) }
  end
end
