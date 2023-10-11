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
  pending "add some examples to (or delete) #{__FILE__}"
end
