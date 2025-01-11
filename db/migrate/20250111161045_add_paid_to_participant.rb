class AddPaidToParticipant < ActiveRecord::Migration[8.0]
  def change
    add_column :participants, :paid, :boolean, null: false, default: false
  end
end
