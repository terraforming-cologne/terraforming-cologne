class Result < ApplicationRecord
  belongs_to :game
  has_many :seats, through: :game
  has_many :scores, through: :seats

  # TODO: Validate ranking order and no duplicate attendances
end
