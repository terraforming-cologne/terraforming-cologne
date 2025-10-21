class Result < ApplicationRecord
  belongs_to :game
  has_many :seats, through: :game
  has_many :scores, through: :seats
  has_one :tournament, through: :game

  validates :game, uniqueness: true
  validates :generations, numericality: {greater_than_or_equal_to: 1}
end
