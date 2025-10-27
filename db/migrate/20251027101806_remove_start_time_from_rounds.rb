class RemoveStartTimeFromRounds < ActiveRecord::Migration[8.0]
  def up
    remove_column :rounds, :start_time
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
