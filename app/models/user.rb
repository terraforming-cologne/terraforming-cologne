class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :participations, dependent: :restrict_with_error

  scope :active, -> { where(deactivated: false) }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  has_secure_password

  validates :name, presence: true, uniqueness: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 8}, if: :password_digest_changed?

  enum :locale, %w[en de].index_by(&:itself), validate: true

  def participating?(tournament = Tournament.next)
    participations.exists?(tournament: tournament)
  end

  def next_participation
    participations.find_by(tournament: Tournament.next)
  end

  def deactivate!
    transaction do
      update! name: "[DELETED-#{id}]", email_address: "#{id}@deleted.de", deactivated: true
      sessions.delete_all
    end
  end
end
