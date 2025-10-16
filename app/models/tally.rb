class Tally
  include ActiveModel::Model

  attr_accessor :result, :scores

  validate :ensure_valid_result
  validate :ensure_valid_scores
  validate :ensure_
  validate :ensure_plausible_ranks

  def self.build_for(game:)
    result = game.build_result
    scores = game.seats.map { |seat| seat.build_score }
    Tally.new(result: result, scores: scores)
  end

  def save
    return false unless valid?

    ApplicationRecord.transaction do
      result.save!
      scores.each(&:save!)
    end

    true
  rescue
    false
  end

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
    if scores.any?(&:invalid?)
      errors.add(:scores, :invalid)
    end
  end

  def ensure_plausible_ranks
    if scores.sort_by(&:rank).each_cons(2).any? { |a, b| a.points < b.points }
      errors.add(:base, :inplausible_ranks)
    end
  end
end
