class Round < ApplicationRecord
  belongs_to :tournament
  has_many :games
  has_many :attendances
  has_many :participations, through: :attendances

  validates :number, numericality: {greater_than: 0}
  validates :board, presence: true
  validates :start_time, presence: true

  default_scope { order(:number) }

  scope :ready_for_ranking, -> { joins(:attendances).group(:id).having("COUNT(attendances.id) > 0") }

  def create_games!
    ApplicationRecord.transaction do
      r = ranking
      groups_of_fours_and_threes(r.size).map { |group_size| r.slice!(0, group_size) }.each_with_index do |group, index|
        games.create!(table: tournament.tables[index]).tap do |game|
          group.each_with_index do |attendance, index|
            game.seats.create!(number: index + 1, attendance: attendance)
          end
        end
      end
    end
  end

  def ranking
    if first_round?
      attendances.shuffle
    else
      attendances.sort_by { it.participation.ranking_criteria(previous_round) }.reverse
    end
  end

  def average_ranking_points
    @average_ranking_points ||= begin
      return 1 if first_round?
      (attendances.sum { it.participation.ranking_points_up_to(self) } / attendances.size.to_f).round
    end
  end

  private

  def groups_of_fours_and_threes(n)
    remainder = n % 4
    while remainder % 3 != 0 && remainder.positive?
      remainder += 4
    end
    fours = (n - remainder) / 4
    threes = remainder / 3
    raise ArgumentError, "cannot split #{n} into groups of 4 and 3" if fours.negative? || threes.negative?
    [[4] * fours, [3] * threes].flatten
  end

  def first_round?
    number == 1
  end

  def previous_round
    tournament.rounds.find_by(number: number - 1)
  end
end
