class Ranking
  def initialize(round)
    @round = round
  end

  def to_a
    @round.tournament.participations.sort_by { |participation| criteria(participation) }.reverse!
  end

  def criteria(participation)
    [
      points_of(participation),
      opponent_points_of(participation),
      average_points_per_generation_of(participation)
    ]
  end

  private

  def points_of(participation)
    return participation.score if participation.is_a?(VirtualPlayer)
    scores_for(participation).sum { |score| ranking_points(score) }
  end

  def opponent_points_of(participation)
    opponents_for(participation).sum { |participation| points_of(participation) }
  end

  def average_points_per_generation_of(participation)
    (scores_for(participation).sum(&:points) / scores_for(participation).map(&:result).sum(&:generations).to_f).round(2)
  end

  def scores_for(participation)
    participation.scores.joins(seat: {game: :round}).where(rounds: {id: rounds})
  end

  def opponents_for(participation)
    rounds.flat_map do |round|
      o = participation.games
        .where(round: round)
        .flat_map(&:participations)
        .excluding(participation)
      if o.size == 2
        o << VirtualPlayer.new(round_average_score)
      end
      o
    end
  end

  def round_average_score
    return 1 if @round.number == 1
    (@round.participations.sum { |participation| points_of(participation) } / @round.participations.count.to_f).round
  end

  def rounds
    [@round, *previous_rounds]
  end

  def previous_rounds
    @round.tournament.rounds.where(number: ...@round.number)
  end

  def ranking_points(score)
    return 5 if score.rank == 1
    5 - score.rank
  end

  class VirtualPlayer
    attr_reader :score

    def initialize(score)
      @score = score
    end
  end
end
