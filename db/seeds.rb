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
3.times do |i|
  tournament.rounds.create! number: i + 1, board: "Board #{i}"
end
93.times do |i|
  user = User.create!(
    name: "User #{i}",
    email_address: "#{i}@example.com",
    password: "asdfasdf",
    password_confirmation: "asdfasdf",
    locale: :en
  )
  user.participations.create!(
    tournament: tournament,
    brings_basegame_english: true,
    brings_basegame_german: false,
    brings_prelude_english: true,
    brings_prelude_german: false,
    brings_hellas_and_elysium: false,
    paid: true
  )
end
5.times do |r|
  room = tournament.rooms.create!(number: r)
  5.times do |t|
    room.tables.create!(number: t)
  end
end
