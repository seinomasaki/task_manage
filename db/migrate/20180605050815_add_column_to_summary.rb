class AddColumnToSummary < ActiveRecord::Migration[5.2]
  def change
    add_column :summaries, :group_id, :integer
  end
end
