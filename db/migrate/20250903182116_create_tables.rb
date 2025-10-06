class CreateTables < ActiveRecord::Migration[8.0]
  def change
    create_table :tables do |t|
      t.integer :number, null: false
      t.belongs_to :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
