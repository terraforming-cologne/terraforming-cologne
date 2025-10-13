class Attendance < ApplicationRecord
  include Ranking

  belongs_to :participation
  has_one :seat
  has_many :games, through: :seat
  has_one :user, through: :participation
  has_one :tournament, through: :participation

  def game_in(round)
    games.includes(:round).find { |game| game.round == round }
  end

  def opponents_in(round)
    game_in(round).attendances.excluding(self)
  end
end
