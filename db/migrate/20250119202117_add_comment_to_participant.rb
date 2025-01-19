class AddCommentToParticipant < ActiveRecord::Migration[8.0]
  def change
    add_column :participants, :comment, :text, null: true
  end
end
