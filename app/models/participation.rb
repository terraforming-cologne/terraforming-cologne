class Participation < ApplicationRecord
  include Ranking

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

  def is_opponent_of?(other, round)
    other != self && other.games.filter { it.round.number <= round.number }.flat_map(&:participations).include?(self)
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
