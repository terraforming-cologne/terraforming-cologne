class Score < ApplicationRecord
  belongs_to :seat
  has_one :result, through: :seat
  has_one :game, through: :seat
  has_one :round, through: :game
end
