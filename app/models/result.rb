class Result < ApplicationRecord
  belongs_to :game
  has_many :seats, through: :game
  has_many :scores, through: :seats
  accepts_nested_attributes_for :game

  # validate :ranking_order_stuff

  # def ranking_order_stuff
  #   debugger
  #   # return false
  #   true
  # end
end
