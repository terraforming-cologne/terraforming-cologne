class Room < ApplicationRecord
  belongs_to :tournament
  has_many :tables
  has_many :games, through: :tables
end
