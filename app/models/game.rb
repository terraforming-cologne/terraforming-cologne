class Game < ApplicationRecord
  belongs_to :table
  belongs_to :round
  has_one :result
  has_one :room, through: :table
  has_one :tournament, through: :round
  has_many :seats
  has_many :attendances, through: :seats
  has_many :scores, through: :seats

  def tallied?
    result.present? && scores.size == seats.size
  end

  def three_players?
    seats.size == 3
  end
end
