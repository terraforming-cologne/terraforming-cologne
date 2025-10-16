class Attendance < ApplicationRecord
  include Ranking

  belongs_to :participation
  has_one :seat
  has_many :games, through: :seat
  has_one :user, through: :participation
  has_one :tournament, through: :participation
end
