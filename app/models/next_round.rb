class NextRound
  include ActiveModel::Model

  attr_accessor :tournament, :participation_ids

  validates :tournament, presence: true
  validate :ensure_all_results_recorded

  def save
    return false unless valid?

    ApplicationRecord.transaction do
      create_attendances_for_next_round!
      next_round.create_games!
      tournament.next_round!
    end

    true
  end

  def current_round
    @current_round ||= tournament.current_round
  end

  def next_round
    @next_round ||= tournament.next_round
  end

  def egligible_participations
    @egligible_participations ||= Participation.where(id: (tournament.current_round || tournament.first_round).attendances.extract_associated(:participation).pluck(:id))
  end

  private

  def ensure_all_results_recorded
    unless current_round.games.all?(&:tallied?)
      errors.add(:base, :not_all_results_recorded)
    end
  end

  def create_attendances_for_next_round!
    egligible_participations.where(id: participation_ids).find_each do |participation|
      Attendance.create! participation: participation, round_id: next_round.id
    end
  end
end
