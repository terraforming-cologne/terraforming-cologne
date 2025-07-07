class TournamentStub < ActiveRecord::Base
  self.table_name = "tournaments"
end

class ParticipantStub < ActiveRecord::Base
  self.table_name = "participants"
end

class ChangeParticipantsToParticipations < ActiveRecord::Migration[8.0]
  def up
    TournamentStub.create!(name: "Dummy Tournament", date: 12.months.from_now.to_date, max_participations: 0) unless TournamentStub.any?
    add_reference :participants, :tournament, null: true, foreign_key: true
    ParticipantStub.update_all(tournament_id: TournamentStub.first.id)
    change_column_null :participants, :tournament_id, false

    add_index :participants, [:tournament_id, :user_id], unique: true
    add_column :participants, :rank, :integer, null: true

    rename_table :participants, :participations
  end

  def down
    rename_table :participations, :participants
    remove_column :participants, :rank
    remove_index :participants, [:tournament_id, :user_id]
    remove_reference :participants, :tournament, foreign_key: true
  end
end
