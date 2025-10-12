class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :participation, null: false, foreign_key: true, index: {unique: true}

      t.timestamps
    end

    add_reference :seats, :attendance, null: false, foreign_key: true
    remove_reference :seats, :participation, null: false, foreign_key: true
  end
end
