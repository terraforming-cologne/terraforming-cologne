module Participation::Ranking
  extend ActiveSupport::Concern

  included do
    has_many :attendances
    has_many :seats, through: :attendances
    has_many :games, through: :seats
    has_many :scores, through: :seats
    has_many :rounds, through: :games

    scope :with_ranking_data, -> {
      includes(
        :rounds,
        {scores: [:round, :result]}, # ranking_points_up_to and average_points_per_generation_up_to
        {games: [:round, {
          participations: [:rounds, {scores: :round}] # opponent_ranking_points_up_to
        }]}
      )
    }
  end

  def ranking_criteria(round)
    [
      ranking_points_up_to(round),
      opponent_ranking_points_up_to(round),
      average_points_per_generation_up_to(round)
    ]
  end

  def ranking_points_up_to(round)
    scores_until(round).sum(&:ranking_points)
  end

  def opponent_ranking_points_up_to(round)
    opponents(round).sum do |participation|
      real_ranking_points = participation.ranking_points_up_to(round)
      if rounds.include?(round)
        real_ranking_points
      else
        [round.average_ranking_points, real_ranking_points].max
      end
    end
  end

  def average_points_per_generation_up_to(round)
    (scores_until(round).sum(&:points) / scores_until(round).map(&:result).sum(&:generations).to_f).round(2).tap { |v| return 0 if v.nan? }
  end

  def rank_in(round)
    scores.find { it.round == round }&.rank
  end

  # private

  def scores_until(round)
    @scores_until ||= {}
    @scores_until[round.id] ||= scores.filter { it.round.number <= round.number }
  end

  def opponents(round)
    expected_number_of_opponents = round.number * 3
    real_opponents = games.filter { it.round.number <= round.number }.flat_map(&:participations).excluding(self)

    remaining_number_of_opponents = expected_number_of_opponents - real_opponents.size
    virtual_opponents = [virtual_participation_for(round)] * remaining_number_of_opponents

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
