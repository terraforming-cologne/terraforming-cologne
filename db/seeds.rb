# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

user = User.create!(
  name: "Admin",
  admin: true,
  email_address: "admin@example.com",
  password: "asdfasdf",
  password_confirmation: "asdfasdf",
  locale: :en
)
tournament = Tournament.create!(
  name: "German Open 2025",
  date: Date.new(2025, 4, 5),
  max_participations: 100
)
user.participations.create!(
  tournament: tournament,
  brings_basegame_english: true,
  brings_basegame_german: false,
  brings_prelude_english: true,
  brings_prelude_german: false,
  brings_hellas_and_elysium: false,
  paid: false
)
