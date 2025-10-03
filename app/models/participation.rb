class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :tournament
  has_many :seats
  has_many :games, through: :seats
  has_many :scores, through: :seats

  scope :active, -> { joins(:user).merge(User.active) }

  after_create_commit :deliver_confirmation_email_later
  after_update_commit :deliver_paid_email_later, if: :updated_to_paid?
  after_destroy_commit :deliver_cancellation_email_later

  def brings_anything?
    brings_basegame_english? ||
      brings_basegame_german? ||
      brings_prelude_english? ||
      brings_prelude_german? ||
      brings_hellas_and_elysium?
  end

  def points(rounds)
    round_scores(rounds).sum(&:ranking_points)
  end

  def opponent_points(rounds)
    opponents(rounds).sum { it.points(rounds) } + three_player_adjustment(rounds.max_by(&:number))
  end

  def average_points_per_generation(rounds)
    (round_scores(rounds).sum(&:points) / round_scores(rounds).map(&:result).sum(&:generations).to_f).round(2)
  end

  def opponents(rounds)
    games
      .where(round: rounds)
      .flat_map(&:participations)
      .excluding(self)
  end

  def round_scores(rounds)
    scores
      .joins(seat: {game: :round})
      .where(rounds: {id: rounds})
  end

  def three_player_adjustment(round)
    return round.average_score if games.count { it.three_players? }
    0
  end

  private

  def updated_to_paid?
    paid_previously_was == false && paid == true
  end

  def deliver_confirmation_email_later
    UserMailer.with(user: user).confirmation.deliver_later
  end

  def deliver_paid_email_later
    UserMailer.with(user: user).paid.deliver_later
  end

  def deliver_cancellation_email_later
    OrgaMailer.cancellation(user, self).deliver_now
  end
end
