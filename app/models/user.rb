class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :participants, dependent: :restrict_with_error

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true, uniqueness: true
  validates :email_address, presence: true, uniqueness: true
  has_secure_password

  after_create_commit :deliver_welcome_email_later

  private

  def deliver_welcome_email_later
    UserMailer.with(user: self).welcome.deliver_later
  end
end
