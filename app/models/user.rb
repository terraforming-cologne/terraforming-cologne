class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :participants, dependent: :restrict_with_error

  scope :active, -> { where(deactivated: false) }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true, uniqueness: true
  validates :email_address, presence: true, uniqueness: true
  has_secure_password

  after_create_commit :deliver_welcome_email_later

  def participating?
    participants.any?
  end

  def deactivate!
    transaction do
      update! name: "[DELETED]", email_address: "#{id}@deleted.de", deactivated: true
      sessions.delete_all
    end
  end

  private

  def deliver_welcome_email_later
    UserMailer.welcome(self).deliver_later
  end
end
