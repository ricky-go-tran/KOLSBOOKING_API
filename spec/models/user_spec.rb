# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  jti                    :string           not null
#  provider               :string
#  uid                    :string
#  status                 :string           default("invalid"), not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { subject.should validate_presence_of(:email) }
    it { subject.should validate_presence_of(:password) }
  end
end
