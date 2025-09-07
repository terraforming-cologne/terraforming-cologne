class Room < ApplicationRecord
  belongs_to :tournament
  has_many :tables
end
