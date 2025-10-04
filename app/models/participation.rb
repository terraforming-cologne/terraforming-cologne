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
    opponents(rounds).sum { it.points(rounds) }
  end

  def average_points_per_generation(rounds)
    (round_scores(rounds).sum(&:points) / round_scores(rounds).map(&:result).sum(&:generations).to_f).round(2)
  end

  # TODO: This feels weird
  class VirtualPlayer
    def initialize(score)
      @score = score
    end

    def points(rounds)
      @score
    end
  end

  def opponents(rounds)
    rounds.flat_map do |round|
      o = games
        .where(round: round)
        .flat_map(&:participations)
        .excluding(self)
      if o.size == 2
        o << VirtualPlayer.new(rounds.max_by(&:number).average_score)
      end
      o
    end
  end

  def round_scores(rounds)
    scores
      .joins(seat: {game: :round})
      .where(rounds: {id: rounds})
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
