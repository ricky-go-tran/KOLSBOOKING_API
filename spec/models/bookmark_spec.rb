# == Schema Information
#
# Table name: bookmarks
#
#  id             :bigint           not null, primary key
#  kol_profile_id :bigint           not null
#  job_id         :bigint           not null
#  status         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe 'association' do
    it { should belong_to(:job) }
    it { should belong_to(:kol_profile) }
  end
end
