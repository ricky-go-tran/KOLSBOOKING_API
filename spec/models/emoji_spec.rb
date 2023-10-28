# == Schema Information
#
# Table name: emojis
#
#  id             :bigint           not null, primary key
#  status         :string           not null
#  emojiable_type :string           not null
#  emojiable_id   :bigint           not null
#  profile_id     :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe Emoji, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:status) }
  end
  describe 'association' do
    it { should belong_to(:profile) }

    it 'is polymorphic' do
      expect(Emoji.reflect_on_association(:emojiable).options[:polymorphic]).to be true
    end
  end
end
