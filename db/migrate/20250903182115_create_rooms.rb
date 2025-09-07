class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.integer :number, null: false
      t.belongs_to :tournament, null: false, foreign_key: true

      t.timestamps
    end
  end
end
