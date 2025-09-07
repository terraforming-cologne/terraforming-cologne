class CreateResults < ActiveRecord::Migration[8.0]
  def change
    create_table :results do |t|
      t.integer :generations, null: false
      t.belongs_to :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
