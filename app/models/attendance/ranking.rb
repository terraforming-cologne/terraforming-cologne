module Attendance::Ranking
  extend ActiveSupport::Concern

  included do
    has_many :seats
    has_many :games, through: :seats
    has_many :scores, through: :seats
    has_many :rounds, through: :games

    scope :with_ranking_data, -> {
      includes(
        :rounds,
        {scores: [:round, :result]}, # ranking_points_up_to and average_points_per_generation_up_to
        {games: [:round, {
          attendances: [:rounds, {scores: :round}] # opponent_ranking_points_up_to
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
    opponents(round).sum do |attendance|
      real_ranking_points = attendance.ranking_points_up_to(round)
      if rounds.include?(round)
        real_ranking_points
      else
        [round.average_ranking_points, real_ranking_points].max
      end
    end
  end

  def average_points_per_generation_up_to(round)
    (scores_until(round).sum(&:points) / scores_until(round).map(&:result).sum(&:generations).to_f).round(2)
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
    real_opponents = games.filter { it.round.number <= round.number }.flat_map(&:attendances).excluding(self)

    remaining_number_of_opponents = expected_number_of_opponents - real_opponents.size
    virtual_opponents = [virtual_attendance_for(round)] * remaining_number_of_opponents

    [*real_opponents, *virtual_opponents]
  end

  def virtual_attendance_for(round)
    @virtual_attendance_for ||= {}
    @virtual_attendance_for[round.id] ||= VirtualAttendance.new(round.average_ranking_points)
  end

  class VirtualAttendance
    def initialize(ranking_points)
      @ranking_points = ranking_points
    end

    def ranking_points_up_to(round)
      @ranking_points
    end
  end
end
