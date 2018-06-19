class AddColumnUserIdInTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :summaries, :user_id, :string
  end
end
