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
class Industry < ApplicationRecord
  has_many :industry_associations
end
