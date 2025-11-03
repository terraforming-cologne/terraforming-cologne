class Table < ApplicationRecord
  belongs_to :room
  has_many :games
  has_many :users, through: :games

  validates :number, presence: true
end
