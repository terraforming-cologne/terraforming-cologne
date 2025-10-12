class Tournament < ApplicationRecord
  FEW_SPOTS_LEFT_THRESHOLD = 0.8

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

  def number_of_full_game_sets
    [
      participations.where(brings_basegame_english: true).count,
      participations.where(brings_basegame_german: true).count,
      participations.where(brings_prelude_english: true).count,
      participations.where(brings_prelude_german: true).count,
      participations.where(brings_hellas_and_elysium: true).count
    ].min
  end

  def max_participations_reached?
    participations.count >= max_participations
  end

  def any_spots_left?
    !max_participations_reached?
  end

  def few_spots_left?
    (participations.count / max_participations.to_f) >= FEW_SPOTS_LEFT_THRESHOLD
  end

  def spots_left
    max_participations - participations.count
  end

  def to_param
    "#{id}-#{name}".parameterize
  end
end
