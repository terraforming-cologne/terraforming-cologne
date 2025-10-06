class Tournament < ApplicationRecord
  has_many :participations
  has_many :rounds
  has_many :games, through: :rounds
  has_many :rooms
  has_many :tables, through: :rooms

  validates :name, presence: true
  validates :date, uniqueness: true
  validates :max_participations, presence: true, numericality: {greater_than_or_equal_to: 0}

  def self.next
    where(date: Date.current..).order(:date).first
  end

  def self.planned?
    where(date: Date.current..).exists?
  end

  def max_participations_reached?
    participations.count >= max_participations
  end

  def spots_left?
    !max_participations_reached?
  end

  def spots_left
    max_participations - participations.count
  end

  def to_param
    "#{id}-#{name}".parameterize
  end
end
