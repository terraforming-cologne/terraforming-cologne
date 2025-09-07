class Round < ApplicationRecord
  belongs_to :tournament
  has_many :games
  has_many :participations, through: :tournament

  def create_games
    o = ordered_participations
    ApplicationRecord.transaction do
      groups_for_tables(o.size).map{|group_size| o.slice!(0,group_size)}.each_with_index do |group, index|
        game = games.create! table: tournament.tables[index]
        group.each_with_index do |participation, index|
          game.seats.create! number: index + 1, participation: participation
        end
      end
    end
  end

  private

  def first_round?
    number == 1
  end

  def ordered_participations
    if first_round?
      tournament.participations.shuffle
    else
      previous_round.ranking.to_a
    end
  end

  def previous_round
    tournament.rounds.find_by(number: number - 1)
  end

  def ranking
    # TODO: Ranking logic. Ranking model?
    tournament.participations
  end

  def groups_for_tables(n)
    remainder = n % 4
    while remainder % 3 != 0 && remainder.positive?
      remainder += 4
    end
    fours  = (n - remainder) / 4
    threes = remainder / 3
    raise ArgumentError, "cannot split #{n} into groups of 4 and 3" if fours.negative? || threes.negative?
    [[4] * fours, [3] * threes].flatten
  end
end
