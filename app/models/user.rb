class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :participants, dependent: :restrict_with_error

  scope :active, -> { where(deactivated: false) }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true, uniqueness: true
  validates :email_address, presence: true, uniqueness: true
  has_secure_password

  enum :locale, %w[en de].index_by(&:itself)

  def participating?
    participants.any?
  end

  def deactivate!
    transaction do
      update! name: "[DELETED-#{id}]", email_address: "#{id}@deleted.de", deactivated: true
      sessions.delete_all
    end
  end
end
