class Score < ApplicationRecord
  belongs_to :seat
  has_one :result, through: :seat
  has_one :game, through: :seat
  has_one :user, through: :seat
  has_one :round, through: :game

  validates :rank, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 4}
  validates :points, numericality: {greater_than_or_equal_to: 0}

  # TODO: Extract corporations into model
  validates :corporation, presence: true

  def ranking_points
    return 5 if rank == 1
    5 - rank
  end
end
