class CreateSeats < ActiveRecord::Migration[8.0]
  def change
    create_table :seats do |t|
      t.integer :number, null: false
      t.belongs_to :game, null: false, foreign_key: true
      t.belongs_to :participation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
