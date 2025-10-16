class Seat < ApplicationRecord
  belongs_to :game
  belongs_to :attendance
  has_one :score
  has_one :round, through: :game
  has_one :result, through: :game
  has_one :table, through: :game
  has_one :room, through: :game
  has_one :user, through: :attendance
end
