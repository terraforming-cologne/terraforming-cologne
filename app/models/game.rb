class Game < ApplicationRecord
  belongs_to :table
  belongs_to :round
  has_one :result
  has_one :room, through: :table
  has_one :tournament, through: :round
  has_many :seats
  has_many :attendances, through: :seats
  has_many :participations, through: :attendances
  has_many :users, through: :participations
  has_many :scores, through: :seats

  def tallied?
    Tally.new(game: self).persisted?
  end

  def three_players?
    seats.size == 3
  end
end
