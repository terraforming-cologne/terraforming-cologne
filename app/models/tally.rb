class Tally
  extend ActiveModel::Callbacks
  include ActiveModel::Model
  include Turbo::Broadcastable

  attr_accessor :result, :scores

  validate :ensure_valid_result
  validate :ensure_valid_scores
  validate :ensure_plausible_ranks
  validate :ensure_same_game_for_all_records
  validate :ensure_one_score_for_each_attendance

  define_model_callbacks :commit
  broadcasts_refreshes_to ->(tally) { [tally.result.tournament, :tallies] }

  def self.build_for(game:)
    result = game.build_result
    scores = game.seats.map { |seat| seat.build_score }
    Tally.new(result: result, scores: scores)
  end

  def save
    return false unless valid?

    run_callbacks(:commit) do
      ApplicationRecord.transaction do
        result.save!
        scores.each(&:save!)
      end
    end

    true
  end

  # NOTE: The following two methods mimic the behavoir of accepts_nested_attributes_for.

  def result_attributes=(result_attributes)
    @result ||= Result.new(result_attributes)
  end

  def scores_attributes=(scores_attributes)
    @scores ||= scores_attributes.values.map { |score_attributes| Score.new(score_attributes) }
  end

  private

  def ensure_valid_result
    if result.invalid?
      errors.add(:result, :invalid)
    end
  end

  def ensure_valid_scores
    # NOTE: We call filter before any? to ensure that the validations add errors to *all* invalid models.
    if scores.filter(&:invalid?).any?
      errors.add(:scores, :invalid)
    end
  end

  def ensure_plausible_ranks
    return if errors[:scores].present?

    if scores.sort_by(&:rank).each_cons(2).any? { |a, b| a.points < b.points }
      errors.add(:base, :inplausible_ranks)
    end
  end

  def ensure_same_game_for_all_records
    return if errors[:result].present? || errors[:scores].present?

    if [result.game, *scores.map(&:game)].uniq.size != 1
      errors.add(:base, :different_games)
    end
  end

  def ensure_one_score_for_each_attendance
    return if errors[:result].present? || errors[:scores].present?

    if result.game.attendances != scores.map(&:attendance)
      errors.add(:base, :wrong_attendances)
    end
  end
end
