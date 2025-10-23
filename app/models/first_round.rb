class FirstRound
  include ActiveModel::Model

  attr_accessor :tournament

  validates :tournament, presence: true
  validate :ensure_before_first_round

  def save
    return false unless valid?

    ApplicationRecord.transaction do
      tournament.first_round.create_games!
      tournament.next_round!
    end

    true
  end

  private

  def ensure_before_first_round
    if tournament.current_round_number.present?
      errors.add(:base, :not_before_first_round)
    end
  end
end
