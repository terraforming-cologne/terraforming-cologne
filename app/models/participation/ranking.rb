module Participation::Ranking
  extend ActiveSupport::Concern

  def ranking_criteria(round)
    [
      ranking_points_up_to(round),
      opponent_ranking_points_up_to(round),
      average_points_per_generation(round)
    ]
  end

  def ranking_points_up_to(round)
    scores_until(round).sum(&:ranking_points)
  end

  def opponent_ranking_points_up_to(round)
    opponents(round).sum { |opponent| opponent.ranking_points_up_to(round) }
  end

  def average_points_per_generation(round)
    (scores_until(round).sum(&:points) / scores_until(round).map(&:result).sum(&:generations).to_f).round(2)
  end

  private

  def scores_until(round)
    @scores_until ||= {}
    @scores_until[round.id] ||= scores.filter { |score| score.round.number <= round.number }
  end

  def opponents(round)
    real_opponents = tournament.participations.filter { it.is_opponent_of?(self, round) }
    virtual_opponents = [virtual_participation_for(round)] * games.filter { it.round.number <= round.number }.count { it.three_players? }
    [*real_opponents, *virtual_opponents]
  end

  def virtual_participation_for(round)
    @virtual_participation_for ||= {}
    @virtual_participation_for[round.id] ||= VirtualParticipation.new(round.average_ranking_points)
  end

  class VirtualParticipation
    def initialize(ranking_points)
      @ranking_points = ranking_points
    end

    def ranking_points_up_to(round)
      @ranking_points
    end
  end
end
