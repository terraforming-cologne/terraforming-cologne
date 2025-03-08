class Participant < ApplicationRecord
  MAX_PARTICIPANTS = 100

  belongs_to :user

  scope :active, -> { joins(:user).merge(User.active) }

  after_create_commit :deliver_confirmation_email_later
  after_update_commit :deliver_paid_email_later, if: :updated_to_paid?
  after_destroy_commit :deliver_cancellation_email_later, if: :paid?

  validate :max_participants

  def self.spots_left
    MAX_PARTICIPANTS - Participant.count
  end

  def self.max_reached?
    Participant.count >= MAX_PARTICIPANTS
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
    OrgaMailer.cancellation(user).deliver_now
  end

  def max_participants
    errors.add(:base, :max_participants) if Participant.max_reached?
  end
end
