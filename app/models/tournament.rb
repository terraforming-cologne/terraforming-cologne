class Tournament < ApplicationRecord
  has_many :participations, dependent: :restrict_with_error

  validates :name, presence: true
  validates :date, uniqueness: true
  validates :max_participations, presence: true, numericality: {greater_than: 0}

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
