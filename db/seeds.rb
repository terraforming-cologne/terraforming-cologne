# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

User.create!(
  name: "Admin",
  admin: true,
  email_address: "admin@example.com",
  password: "asdfasdf",
  password_confirmation: "asdfasdf",
  locale: :en
)

tournament = Tournament.create!(
  name: "German Open",
  date: Time.zone.today + 1.year,
  max_participations: 100
)

tournament.rounds.insert_all!(
  3.times.map { |i|
    {
      number: i + 1,
      board: "Board #{i}",
      created_at: Time.current,
      updated_at: Time.current
    }
  }
)

password_digest = User.new(password: "asdfasdf", password_confirmation: "asdfasdf").password_digest
users = (0...93).map do |i|
  {
    name: "User #{i}",
    email_address: "#{i}@example.com",
    password_digest: password_digest,
    locale: :en,
    created_at: Time.current,
    updated_at: Time.current
  }
end
User.insert_all!(users)

user_ids = User.where.not(email_address: "admin@example.com").pluck(:id)
participations = user_ids.map do |user_id|
  {
    user_id: user_id,
    tournament_id: tournament.id,
    brings_basegame_english: true,
    brings_basegame_german: false,
    brings_prelude_english: true,
    brings_prelude_german: false,
    brings_hellas_and_elysium: false,
    paid: true,
    created_at: Time.current,
    updated_at: Time.current
  }
end
Participation.insert_all!(participations)

rooms = (0...5).map { |r|
  {
    number: r,
    tournament_id: tournament.id,
    created_at: Time.current,
    updated_at: Time.current
  }
}
Room.insert_all!(rooms)

room_ids = Room.where(tournament_id: tournament.id).pluck(:id)
tables = room_ids.flat_map do |room_id|
  (0...5).map { |t|
    {
      number: t,
      room_id: room_id,
      created_at: Time.current,
      updated_at: Time.current
    }
  }
end
Table.insert_all!(tables)
