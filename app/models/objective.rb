class Objective < ApplicationRecord
  has_many :emojis
  has_many :reports
end
