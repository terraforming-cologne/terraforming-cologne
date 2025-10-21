# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

now = Time.current

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

tournament.rounds.insert!({
  number: 1,
  board: "Tharsis",
  start_time: Time.zone.today + 1.year + 9.hours,
  created_at: now,
  updated_at: now
})
tournament.rounds.insert!({
  number: 2,
  board: "Hellas",
  start_time: Time.zone.today + 1.year + 11.hours,
  created_at: now,
  updated_at: now
})
tournament.rounds.insert!({
  number: 3,
  board: "Elysium",
  start_time: Time.zone.today + 1.year + 13.hours,
  created_at: now,
  updated_at: now
})

password_digest = User.new(password: "asdfasdf", password_confirmation: "asdfasdf").password_digest
users = (1..93).map do |i|
  {
    name: "User #{i}",
    email_address: "#{i}@example.com",
    password_digest: password_digest,
    locale: :en,
    created_at: now,
    updated_at: now
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
    brings_hellas_and_elysium: true,
    paid: true,
    created_at: now,
    updated_at: now
  }
end
Participation.insert_all!(participations)

rooms = (1..3).map { |r|
  {
    number: r,
    tournament_id: tournament.id,
    created_at: now,
    updated_at: now
  }
}
Room.insert_all!(rooms)

tables = []
table_counts = [20, 6, 5]
i = 0
room_ids = Room.where(tournament_id: tournament.id).pluck(:id)
room_ids.zip(table_counts).each do |room_id, count|
  count.times do
    tables << {
      number: i + 1,
      room_id: room_id,
      created_at: now,
      updated_at: now
    }
    i += 1
  end
end
Table.insert_all(tables)
