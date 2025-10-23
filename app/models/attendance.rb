class Attendance < ApplicationRecord
  include Ranking

  belongs_to :participation
  belongs_to :round
  has_one :user, through: :participation
  has_one :tournament, through: :participation
end
