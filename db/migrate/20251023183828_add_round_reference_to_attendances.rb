class AddRoundReferenceToAttendances < ActiveRecord::Migration[8.0]
  def change
    add_reference :attendances, :round, null: true, foreign_key: true
    reversible do |direction|
      direction.up do
        execute <<~SQL
          UPDATE attendances
          SET round_id = 1;

          INSERT INTO attendances (participation_id, round_id, created_at, updated_at)
          SELECT participation_id, 2, created_at, updated_at
          FROM attendances
          WHERE round_id = 1;

          INSERT INTO attendances (participation_id, round_id, created_at, updated_at)
          SELECT participation_id, 3, created_at, updated_at
          FROM attendances
          WHERE round_id = 1;
        SQL
      end
    end
    change_column_null :attendances, :round_id, false
  end
end
