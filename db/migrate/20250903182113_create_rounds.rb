class CreateRounds < ActiveRecord::Migration[8.0]
  def change
    create_table :rounds do |t|
      t.integer :number, null: false
      t.string :board, null: false
      t.belongs_to :tournament, null: false, foreign_key: true

      t.timestamps
    end
  end
end
