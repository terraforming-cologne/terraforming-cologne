class Seat < ApplicationRecord
  belongs_to :game
  belongs_to :participation
  has_one :score
  has_one :round, through: :game
  accepts_nested_attributes_for :score
end
