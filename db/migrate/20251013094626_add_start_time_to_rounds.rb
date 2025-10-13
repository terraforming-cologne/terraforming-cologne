class AddStartTimeToRounds < ActiveRecord::Migration[8.0]
  def change
    add_column :rounds, :start_time, :time, null: true
    reversible do |direction|
      direction.up do
        execute <<~SQL
          UPDATE rounds
          SET start_time = datetime('now');
        SQL
      end
    end
    change_column_null :rounds, :start_time, false
  end
end
