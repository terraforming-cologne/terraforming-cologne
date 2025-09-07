class Game < ApplicationRecord
  belongs_to :table
  belongs_to :round
  has_one :result
  has_one :tournament, through: :round
  has_many :seats
  has_many :participations, through: :seats
  has_many :scores, through: :seats
  accepts_nested_attributes_for :seats
end
