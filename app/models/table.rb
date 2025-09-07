class Table < ApplicationRecord
  belongs_to :room
  has_many :games
end
