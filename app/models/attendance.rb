class Attendance < ApplicationRecord
  belongs_to :participation
  belongs_to :round
  has_one :seat
  has_one :table, through: :seat
  has_one :room, through: :table
  has_one :game, through: :seat
  has_one :result, through: :game
  has_one :user, through: :participation
  has_one :tournament, through: :participation

  broadcasts_refreshes_to ->(attendance) { [attendance.tournament, :bridge] }
end
