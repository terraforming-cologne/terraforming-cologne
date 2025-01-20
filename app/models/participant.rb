class Participant < ApplicationRecord
  belongs_to :user

  scope :active, -> { joins(:user).merge(User.active) }

  after_create_commit :deliver_confirmation_email_later
  after_update_commit :deliver_paid_email_later, if: :updated_to_paid?

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
end
