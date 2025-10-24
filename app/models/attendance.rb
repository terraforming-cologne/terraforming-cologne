class Attendance < ApplicationRecord
  include Ranking

  belongs_to :participation
  belongs_to :round
  has_one :seat
  has_one :game, through: :seat
  has_one :result, through: :game
  has_one :user, through: :participation
  has_one :tournament, through: :participation
end
