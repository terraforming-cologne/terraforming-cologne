class Attendance < ApplicationRecord
  include Ranking

  belongs_to :participation
  has_many :seats
  has_many :games, through: :seats
  has_one :user, through: :participation
  has_one :tournament, through: :participation
end
