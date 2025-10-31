class Tournament < ApplicationRecord
  FEW_SPOTS_LEFT_THRESHOLD = 0.8

  has_many :participations
  has_many :attendances, through: :participations
  has_many :rounds
  has_many :games, through: :rounds
  has_many :rooms
  has_many :tables, through: :rooms

  validates :name, presence: true
  validates :date, uniqueness: true
  validates :max_participations, numericality: {greater_than_or_equal_to: 0}

  def self.next
    where(date: Date.current..).order(:date).first
  end

  def self.planned?
    where(date: Date.current..).exists?
  end

  def groups_of_fours_and_threes
    n = participations.where(paid: true).count
    remainder = n % 4
    while remainder % 3 != 0 && remainder.positive?
      remainder += 4
    end
    fours = (n - remainder) / 4
    threes = remainder / 3
    raise ArgumentError, "cannot split #{n} into groups of 4 and 3" if fours.negative? || threes.negative?
    [[4] * fours, [3] * threes].flatten
  end

  def current_round
    rounds.find_by(number: current_round_number)
  end

  def first_round
    rounds.find_by(number: 1)
  end

  def next_round
    rounds.find_by(number: (current_round_number || 0) + 1)
  end

  def next_round!
    update!(current_round_number: (current_round_number || 0) + 1)
  end

  def number_of_full_game_sets
    [
      participations.where(paid: true, brings_basegame_english: true).count + participations.where(paid: true, brings_basegame_german: true).count,
      participations.where(paid: true, brings_prelude_english: true).count + participations.where(paid: true, brings_prelude_german: true).count,
      participations.where(paid: true, brings_hellas_and_elysium: true).count
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
