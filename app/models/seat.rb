class Seat < ApplicationRecord
  belongs_to :game
  belongs_to :attendance
  has_one :score
  has_one :round, through: :game
  has_one :result, through: :game
end
