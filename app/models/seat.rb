class Seat < ApplicationRecord
  belongs_to :game
  belongs_to :participation
  has_one :score
  accepts_nested_attributes_for :score
end
